@echo off
echo Opening Firebase Console...
echo.
echo Default SHA-1 key for development:
echo 58:E1:C5:71:7A:1A:8E:78:00:00:51:4D:D2:6A:89:A5:C8:E5:8F:BA
echo.
echo This key has been copied to clipboard (if possible)
echo 58:E1:C5:71:7A:1A:8E:78:00:00:51:4D:D2:6A:89:A5:C8:E5:8F:BA | clip
echo.
echo Opening Firebase Console in your browser...
start https://console.firebase.google.com
echo.
echo Instructions:
echo 1. Create or select your project
echo 2. Add Android app with package: com.example.flutter_pro_test
echo 3. Add the SHA-1 fingerprint shown above
echo 4. Download google-services.json
echo 5. Replace android/app/google-services.json with the new file
echo.
pause
