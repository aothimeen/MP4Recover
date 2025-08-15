<?php
  declare(strict_types=1);
  require __DIR__ . '/config.php';

  header('Content-Type: application/json; charset=utf-8');

  $job = isset($_GET['job']) ? (string)$_GET['job'] : '';
  if ($job === '') {
    echo json_encode(['_error' => 'job is required']); exit;
  }

  $api = ORCHESTRATOR_BASE . "/status?" . http_build_query(['job' => $job]);
  $ch = curl_init();
  curl_setopt_array($ch, [
    CURLOPT_URL => $api,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_CONNECTTIMEOUT_MS => 5000,
    CURLOPT_TIMEOUT_MS => 30000,
  ]);
  $resp = curl_exec($ch);
  $http = curl_getinfo($ch, CURLINFO_RESPONSE_CODE);
  $cerr = curl_error($ch);
  curl_close($ch);

  if ($resp === false) {
    echo json_encode(['_error' => "HTTP error: {$cerr}"]); exit;
  }

  if ($http >= 300) {
    echo json_encode(['_error' => "HTTP status {$http}: {$resp}"]); exit;
  }

  echo $resp;
