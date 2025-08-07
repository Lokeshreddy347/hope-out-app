@echo off
echo 🚀 Quick APK Build for Hope Out
echo.

echo Attempting to build APK with workarounds...
echo.

REM Method 1: Try with offline mode
echo Method 1: Building with offline Gradle...
flutter build apk --debug --offline

if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    goto :success
)

echo.
echo Method 1 failed, trying Method 2...
echo.

REM Method 2: Try with no daemon
echo Method 2: Building with no Gradle daemon...
flutter build apk --debug --no-gradle-daemon

if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    goto :success
)

echo.
echo Method 2 failed, trying Method 3...
echo.

REM Method 3: Try building just the Android part
echo Method 3: Building Android directly...
cd android
call gradlew assembleDebug
cd ..

if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    goto :success
)

echo.
echo ❌ All build methods failed.
echo.
echo 💡 Solutions:
echo 1. Restart your computer and try again
echo 2. Run this script as Administrator
echo 3. Close all Android Studio/VS Code instances
echo 4. Try the PowerShell script: .\build_apk.ps1
echo.
goto :end

:success
echo.
echo ✅ APK built successfully!
echo.
echo 📍 Location: build\app\outputs\flutter-apk\app-debug.apk
for %%A in ("build\app\outputs\flutter-apk\app-debug.apk") do echo 📏 Size: %%~zA bytes

echo.
echo 📱 Next steps:
echo 1. Copy app-debug.apk to your Android phone
echo 2. Enable "Install from unknown sources" in Android settings
echo 3. Tap the APK file to install Hope Out
echo.

echo Opening APK folder...
explorer "build\app\outputs\flutter-apk\"

:end
echo.
pause
