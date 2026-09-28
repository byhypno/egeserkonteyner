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
 * One resumable phase of a backup job (scan, archive, verify, ...).
 *
 * run() performs a bounded amount of work (one AJAX request), updates the
 * job state and commits it. When the phase is complete it must move the job
 * to its next status. New phases (for example a database dump) only need to
 * implement this interface and be registered in EgeserBackupManager::phase().
 */
interface EgeserBackupPhaseInterface
{
    /**
     * @param EgeserBackupJob $job
     * @param float $deadline microtime(true) value after which no new work may start
     *
     * @throws EgeserBackupException
     */
    public function run(EgeserBackupJob $job, $deadline);
}
