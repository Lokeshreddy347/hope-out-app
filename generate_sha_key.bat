@echo off
echo Generating SHA-1 key for Firebase...
echo.

REM Find keytool in common Java locations
set KEYTOOL_PATH=
for %%i in (keytool.exe) do set KEYTOOL_PATH=%%~$PATH:i
if not "%KEYTOOL_PATH%"=="" goto :keytool_found

REM Check common Java installation paths
if exist "%JAVA_HOME%\bin\keytool.exe" (
    set KEYTOOL_PATH=%JAVA_HOME%\bin\keytool.exe
    goto :keytool_found
)

if exist "%ProgramFiles%\Java\jdk*\bin\keytool.exe" (
    for /d %%i in ("%ProgramFiles%\Java\jdk*") do (
        if exist "%%i\bin\keytool.exe" (
            set KEYTOOL_PATH=%%i\bin\keytool.exe
            goto :keytool_found
        )
    )
)

if exist "%ProgramFiles(x86)%\Java\jdk*\bin\keytool.exe" (
    for /d %%i in ("%ProgramFiles(x86)%\Java\jdk*") do (
        if exist "%%i\bin\keytool.exe" (
            set KEYTOOL_PATH=%%i\bin\keytool.exe
            goto :keytool_found
        )
    )
)

echo Error: keytool not found. Please install Java JDK or add it to your PATH.
echo You can download Java from: https://www.oracle.com/java/technologies/downloads/
pause
exit /b 1

:keytool_found
echo Found keytool at: %KEYTOOL_PATH%
echo.

REM Create .android directory if it doesn't exist
if not exist "%USERPROFILE%\.android" mkdir "%USERPROFILE%\.android"

REM Check if debug keystore exists, create if not
if not exist "%USERPROFILE%\.android\debug.keystore" (
    echo Creating debug keystore...
    "%KEYTOOL_PATH%" -genkey -v -keystore "%USERPROFILE%\.android\debug.keystore" -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "CN=Android Debug,O=Android,C=US"
    echo Debug keystore created successfully!
    echo.
)

echo Extracting SHA-1 fingerprint from debug keystore...
echo.

"%KEYTOOL_PATH%" -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android | findstr SHA1

echo.
echo Copy the SHA-1 fingerprint above and add it to your Firebase project:
echo 1. Go to Firebase Console (https://console.firebase.google.com)
echo 2. Select your project
echo 3. Go to Project Settings (gear icon)
echo 4. Select your Android app
echo 5. Add the SHA-1 fingerprint
echo 6. Download the updated google-services.json file
echo 7. Replace the existing google-services.json file with the new one
echo.
pause
