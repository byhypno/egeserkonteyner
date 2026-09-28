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
 * Exception whose message is safe to show to the back office user.
 *
 * Messages must never contain absolute server paths or stack traces;
 * every other Throwable is converted into a generic message by the controller
 * and its details are written only to the module log.
 */
class EgeserBackupException extends Exception
{
}
