<?php
$email = $_SERVER['HTTP_AUTOLOGINUSER'] ?? '';
$password = $_SERVER['HTTP_AUTOLOGINPASS'] ?? '';
$targetUrl = '/3rdparty/snappymail/';

if ($email === '' || $password === '') {
    http_response_code(400);
    echo 'Missing webmail credentials.';
    exit;
}

header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');
header('Content-Type: text/html; charset=UTF-8');

function h(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Opening Snappymail</title>
</head>
<body>
  <form id="snappymail-login" method="post" action="<?php echo h($targetUrl); ?>">
    <input type="hidden" name="Email" value="<?php echo h($email); ?>">
    <input type="hidden" name="Password" value="<?php echo h($password); ?>">
    <input type="hidden" name="email" value="<?php echo h($email); ?>">
    <input type="hidden" name="password" value="<?php echo h($password); ?>">
    <input type="hidden" name="Username" value="<?php echo h($email); ?>">
    <input type="hidden" name="userName" value="<?php echo h($email); ?>">
    <input type="hidden" name="signMe" value="1">
  </form>
  <script>
    document.getElementById('snappymail-login').submit();
  </script>
</body>
</html>
