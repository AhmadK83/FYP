<?php
require_once __DIR__.'/includes/functions.php';
require_login();
$pageTitle='Change password — DriveEase';
$errors=[];
if($_SERVER['REQUEST_METHOD']==='POST'){
 verify_csrf();
 $current=$_POST['current_password']??'';
 $new=$_POST['new_password']??'';
 $confirm=$_POST['confirm_password']??'';
 $s=db()->prepare('SELECT password_hash FROM users WHERE id=? AND is_active=1');
 $s->execute([current_user()['id']]);
 $row=$s->fetch();
 if(!$row || !password_verify($current,$row['password_hash'])) $errors[]='Current password is incorrect.';
 if(strlen($new)<8) $errors[]='New password must be at least 8 characters.';
 if($new!==$confirm) $errors[]='New password and confirmation do not match.';
 if(!$errors){$s=db()->prepare('UPDATE users SET password_hash=? WHERE id=?');$s->execute([password_hash($new,PASSWORD_DEFAULT),current_user()['id']]);log_activity('Changed password');flash('success','Password updated successfully.');redirect('dashboard.php');}
}
require __DIR__.'/includes/header.php';
?>
<section class="page-hero page-hero-compact"><div class="container"><span class="eyebrow">ACCOUNT SECURITY</span><h1>Change your <span class="text-gradient">password.</span></h1><p>Choose a unique password of at least eight characters.</p></div></section>
<section class="section"><div class="container content-narrow"><div class="panel form-panel"><h2>Update password</h2><?php if($errors): ?><div class="alert alert-danger"><ul><?php foreach($errors as $er): ?><li><?= e($er) ?></li><?php endforeach; ?></ul></div><?php endif; ?><form method="post" class="form-stack"><?= csrf_field() ?><label>Current password<input required type="password" name="current_password" autocomplete="current-password"></label><label>New password<input required type="password" name="new_password" minlength="8" autocomplete="new-password"></label><label>Confirm new password<input required type="password" name="confirm_password" minlength="8" autocomplete="new-password"></label><div class="form-row"><button class="btn btn-primary">Update password ↗</button><a class="btn btn-ghost" href="<?= e(url('dashboard.php')) ?>">Cancel</a></div></form></div></div></section>
<?php require __DIR__.'/includes/footer.php'; ?>
