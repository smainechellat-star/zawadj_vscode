# Install APK and monitor Firebase Auth logs
$env:ANDROID_HOME = "C:\Users\smain\AppData\Local\Android\sdk"
$adb = "$env:ANDROID_HOME\platform-tools\adb.exe"

Write-Host "Checking for connected devices..." -ForegroundColor Cyan
& $adb devices

Write-Host "`nInstalling APK..." -ForegroundColor Cyan
& $adb install -r "build\app\outputs\flutter-apk\app-release.apk"

Write-Host "`nStarting logcat monitoring..." -ForegroundColor Cyan
Write-Host "Filtering for Firebase Auth and app logs..." -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop monitoring`n" -ForegroundColor Yellow

# Clear logcat first
& $adb logcat -c

# Monitor logs - filter for Firebase, Auth, and our app
& $adb logcat -v time `
  FirebaseAuth:V `
  FirebaseAuthWebException:V `
  PhoneAuthProvider:V `
  AuthService:V `
  zawadj:V `
  *:E
