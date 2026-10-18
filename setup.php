<?php
// Run once from your browser after importing database.sql, then delete this file.
require_once __DIR__.'/includes/functions.php';
try {
 $pdo=db();
 $s=$pdo->prepare('SELECT id FROM users WHERE email=?');$s->execute(['admin@driveease.local']);
 if(!$s->fetch()){$s=$pdo->prepare("INSERT INTO users (name,email,password_hash,phone,role,is_active) VALUES (?,?,?,?, 'admin',1)");$s->execute(['System Administrator','admin@driveease.local',password_hash('Admin@12345',PASSWORD_DEFAULT),null]);$created=true;}else{$created=false;}
 $carCount=(int)$pdo->query('SELECT COUNT(*) FROM cars')->fetchColumn();
} catch(Throwable $ex){http_response_code(500);echo '<h1>Setup failed</h1><p>Confirm that you imported database.sql and configured config.php correctly.</p><pre>'.htmlspecialchars($ex->getMessage(),ENT_QUOTES,'UTF-8').'</pre>';exit;}
?><!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>DriveEase Setup</title><link rel="stylesheet" href="<?= htmlspecialchars(url('assets/style.css'),ENT_QUOTES,'UTF-8') ?>"></head><body><section class="auth-section"><div class="panel content-narrow" style="margin:35px auto;padding:32px"><span class="eyebrow">SETUP COMPLETE</span><h1 style="font-size:2.4rem">DriveEase is ready.</h1><p>Database connection succeeded. Demo fleet rows available: <?= $carCount ?>.</p><?php if($created): ?><div class="alert alert-success">Administrator account created.</div><?php else: ?><div class="alert alert-warning">The administrator account already existed, so its password was not changed.</div><?php endif; ?><p><b>Email:</b> admin@driveease.local<br><b>Password:</b> Admin@12345</p><div class="alert alert-warning">Important: sign in and change this password, then delete setup.php from your project folder.</div><a class="btn btn-primary" href="<?= htmlspecialchars(url('login.php'),ENT_QUOTES,'UTF-8') ?>">Go to sign in ↗</a></div></section></body></html>
