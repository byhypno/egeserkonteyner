<?php
/**
 * Egeser Full Backup
 *
 * @author    Egeser
 * @copyright Egeser
 * @license   Proprietary
 */
if (!defined('_PS_VERSION_')) {
    exit;
}

/**
 * Phase 1: batched, resumable recursive scan of the PrestaShop root.
 *
 * A depth-first stack of pending directories is kept in job.json. Each request
 * pops directories until the time budget is used, lists each directory
 * completely and appends one line per entry to the manifest:
 *
 *   F<TAB>size<TAB>relative/path     regular file
 *   D<TAB>0<TAB>relative/path        empty directory (stored as a ZIP dir entry)
 *
 * Symbolic links: links to directories are never followed (so loops are
 * impossible) and are reported as "skipped". Links to regular files inside
 * the site root are archived with the target content; any other link is
 * skipped and reported.
 */
class EgeserBackupScanner implements EgeserBackupPhaseInterface
{
    public const MAX_DEPTH = 64;

    /** @var EgeserBackupStorage */
    private $storage;

    /**
     * @param EgeserBackupStorage $storage
     */
    public function __construct(EgeserBackupStorage $storage)
    {
        $this->storage = $storage;
    }

    /**
     * {@inheritdoc}
     */
    public function run(EgeserBackupJob $job, $deadline)
    {
        $root = $this->storage->getRoot();
        $rules = new EgeserBackupExclusions($job->data['settings']);
        $stack = $job->data['scan']['stack'];
        $totals = &$job->data['totals'];
        $issues = array();

        $manifest = @fopen($job->manifestFile(), 'ab');
        if ($manifest === false) {
            throw new EgeserBackupException('Manifest dosyası açılamadı.');
        }

        $processedDirs = 0;
        while (!empty($stack)) {
            if ($processedDirs > 0 && microtime(true) >= $deadline) {
                break;
            }
            $relDir = rawurldecode(array_pop($stack));
            $absDir = $relDir === '' ? $root : $root . '/' . $relDir;
            ++$processedDirs;
            ++$job->data['scan']['dirs_scanned'];

            $handle = @opendir($absDir);
            if ($handle === false) {
                if ($relDir === '') {
                    fclose($manifest);
                    throw new EgeserBackupException('Site kök dizini okunamadı.');
                }
                $issues[] = array(EgeserBackupJob::ISSUE_UNREADABLE, $relDir . '/', 'Klasör okunamadı (izin yok).');
                continue;
            }
            $names = array();
            while (($name = readdir($handle)) !== false) {
                if ($name !== '.' && $name !== '..') {
                    $names[] = $name;
                }
            }
            closedir($handle);
            sort($names, SORT_STRING);

            $lines = '';
            $included = 0;
            $subDirs = array();
            foreach ($names as $name) {
                $rel = $relDir === '' ? $name : $relDir . '/' . $name;
                $abs = $absDir . '/' . $name;

                if (preg_match('/[\x00-\x1F\x7F]/', $name)) {
                    $issues[] = array(
                        EgeserBackupJob::ISSUE_SKIPPED,
                        preg_replace('/[\x00-\x1F\x7F]/', '?', $rel),
                        'Dosya adında kontrol karakteri var, atlandı.',
                    );
                    continue;
                }

                if (is_link($abs)) {
                    $line = $this->scanSymlink($abs, $rel, $name, $rules, $issues, $totals);
                    if ($line !== null) {
                        $lines .= $line;
                        ++$included;
                    }
                    continue;
                }

                if (is_dir($abs)) {
                    $reason = $rules->matchDirectory($rel);
                    if ($reason !== null) {
                        ++$totals['excluded'];
                        if (EgeserBackupExclusions::keepsEmptyDirectory($reason)) {
                            $lines .= $this->excludedDirectoryLines($abs, $rel, $issues, $totals);
                            ++$included;
                        }
                        continue;
                    }
                    if (substr_count($rel, '/') >= self::MAX_DEPTH) {
                        $issues[] = array(
                            EgeserBackupJob::ISSUE_SKIPPED,
                            $rel . '/',
                            'Klasör derinliği ' . self::MAX_DEPTH . ' seviyeyi aşıyor, atlandı.',
                        );
                        continue;
                    }
                    $subDirs[] = $rel;
                    ++$included;
                    continue;
                }

                if (!is_file($abs)) {
                    $issues[] = array(EgeserBackupJob::ISSUE_SKIPPED, $rel, 'Özel dosya türü (socket/fifo/aygıt), atlandı.');
                    continue;
                }
                if ($rules->matchFile($rel, $name) !== null) {
                    ++$totals['excluded'];
                    continue;
                }
                $line = $this->fileLine($abs, $rel, $issues, $totals);
                if ($line !== null) {
                    $lines .= $line;
                    ++$included;
                }
            }

            if ($included === 0 && $relDir !== '') {
                $lines .= "D\t0\t" . $relDir . "\n";
                ++$totals['dirs'];
            }
            if ($lines !== '' && fwrite($manifest, $lines) !== strlen($lines)) {
                fclose($manifest);
                throw new EgeserBackupException('Manifest dosyasına yazılamadı. Disk dolu olabilir.');
            }

            // Pushed in reverse order so they are popped alphabetically.
            for ($i = count($subDirs) - 1; $i >= 0; --$i) {
                $stack[] = rawurlencode($subDirs[$i]);
            }
        }

        fflush($manifest);
        fclose($manifest);

        $job->data['scan']['stack'] = array_values($stack);
        if (empty($stack)) {
            $job->data['scan']['finished_at'] = time();
            $job->data['status'] = EgeserBackupJob::STATUS_READY;
        }
        $job->appendIssues($issues);
        $job->commit();
    }

    /**
     * An excluded cache/log directory keeps only its protection files
     * (index.php, .htaccess) so the restored directory is not browsable;
     * without them it is stored as an empty directory.
     *
     * @param string $abs
     * @param string $rel
     * @param array $issues
     * @param array $totals
     *
     * @return string manifest lines
     */
    private function excludedDirectoryLines($abs, $rel, array &$issues, array &$totals)
    {
        $lines = '';
        foreach (array('.htaccess', 'index.php') as $name) {
            $file = $abs . '/' . $name;
            if (is_file($file) && !is_link($file)) {
                $line = $this->fileLine($file, $rel . '/' . $name, $issues, $totals);
                if ($line !== null) {
                    $lines .= $line;
                }
            }
        }
        if ($lines === '') {
            $lines = "D\t0\t" . $rel . "\n";
            ++$totals['dirs'];
        }

        return $lines;
    }

    /**
     * @param string $abs
     * @param string $rel
     * @param array $issues
     * @param array $totals
     *
     * @return string|null manifest line
     */
    private function fileLine($abs, $rel, array &$issues, array &$totals)
    {
        if (!is_readable($abs)) {
            $issues[] = array(EgeserBackupJob::ISSUE_UNREADABLE, $rel, 'Dosya okunamadı (izin yok).');

            return null;
        }
        $size = @filesize($abs);
        if ($size === false) {
            $issues[] = array(EgeserBackupJob::ISSUE_UNREADABLE, $rel, 'Dosya boyutu okunamadı.');

            return null;
        }
        ++$totals['files'];
        $totals['bytes'] += $size;

        return "F\t" . $size . "\t" . $rel . "\n";
    }

    /**
     * @param string $abs
     * @param string $rel
     * @param string $name
     * @param EgeserBackupExclusions $rules
     * @param array $issues
     * @param array $totals
     *
     * @return string|null manifest line
     */
    private function scanSymlink($abs, $rel, $name, EgeserBackupExclusions $rules, array &$issues, array &$totals)
    {
        $target = realpath($abs);
        if ($target === false) {
            $issues[] = array(EgeserBackupJob::ISSUE_SKIPPED, $rel, 'Kırık sembolik bağlantı, atlandı.');

            return null;
        }
        if (is_dir($target)) {
            $issues[] = array(
                EgeserBackupJob::ISSUE_SKIPPED,
                $rel . '/',
                'Klasöre işaret eden sembolik bağlantı takip edilmedi (döngü koruması).',
            );

            return null;
        }
        $root = $this->storage->getRoot();
        $target = EgeserBackupStorage::normalize($target);
        if (strpos($target, $root . '/') !== 0) {
            $issues[] = array(EgeserBackupJob::ISSUE_SKIPPED, $rel, 'Site kökü dışını gösteren sembolik bağlantı, atlandı.');

            return null;
        }
        if (EgeserBackupExclusions::isStoragePath(substr($target, strlen($root) + 1))) {
            ++$totals['excluded'];

            return null;
        }
        if (!is_file($target)) {
            $issues[] = array(EgeserBackupJob::ISSUE_SKIPPED, $rel, 'Sembolik bağlantı normal bir dosyayı göstermiyor, atlandı.');

            return null;
        }
        if ($rules->matchFile($rel, $name) !== null) {
            ++$totals['excluded'];

            return null;
        }

        return $this->fileLine($abs, $rel, $issues, $totals);
    }
}
