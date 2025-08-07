@echo off
echo Building Hope Out APK for Android...
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Running with administrator privileges...
) else (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d %CD% && %0' -Verb RunAs"
    exit /b
)

echo.
echo Step 1: Cleaning project...
flutter clean

echo.
echo Step 2: Getting dependencies...
flutter pub get

echo.
echo Step 3: Building APK (this may take a few minutes)...
flutter build apk --debug

echo.
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo ✅ APK built successfully!
    echo.
    echo APK Location: build\app\outputs\flutter-apk\app-debug.apk
    echo APK Size: 
    for %%A in ("build\app\outputs\flutter-apk\app-debug.apk") do echo %%~zA bytes
    echo.
    echo 📱 To install on your Android device:
    echo 1. Copy app-debug.apk to your phone
    echo 2. Enable "Install from unknown sources" in Android settings
    echo 3. Tap the APK file to install
    echo.
    echo Opening APK folder...
    explorer "build\app\outputs\flutter-apk\"
) else (
    echo ❌ APK build failed. Check the error messages above.
    echo.
    echo Common solutions:
    echo 1. Make sure Android SDK is properly installed
    echo 2. Check that you have enough disk space
    echo 3. Close any antivirus software temporarily
    echo 4. Try running this script as administrator
)

echo.
pause
