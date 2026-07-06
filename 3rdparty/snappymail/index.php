<?php

if (!defined('APP_INDEX_ROOT_PATH')) {
    define('APP_INDEX_ROOT_PATH', __DIR__ . DIRECTORY_SEPARATOR);
}

$versionRoot = APP_INDEX_ROOT_PATH . 'v';
$appVersion = null;

if (is_dir($versionRoot)) {
    $entries = scandir($versionRoot);
    foreach ($entries as $entry) {
        if ($entry === '.' || $entry === '..') {
            continue;
        }
        if (!is_dir($versionRoot . DIRECTORY_SEPARATOR . $entry)) {
            continue;
        }
        if ($appVersion === null || version_compare($entry, $appVersion, '>')) {
            $appVersion = $entry;
        }
    }
}

if ($appVersion !== null && !defined('APP_VERSION')) {
    define('APP_VERSION', $appVersion);
}

if ($appVersion !== null && file_exists(APP_INDEX_ROOT_PATH . 'v/' . APP_VERSION . '/include.php')) {
    include APP_INDEX_ROOT_PATH . 'v/' . APP_VERSION . '/include.php';
    exit;
}

http_response_code(503);
echo 'Snappymail is not fully installed. Missing v/<version>/include.php.';
exit;
