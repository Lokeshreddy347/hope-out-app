# PowerShell script to get SHA-1 key for Firebase
Write-Host "Getting SHA-1 key for Firebase..." -ForegroundColor Green
Write-Host ""

# Method 1: Try to find keytool in Flutter's bundled Java
$flutterPath = (Get-Command flutter -ErrorAction SilentlyContinue).Source
if ($flutterPath) {
    $flutterDir = Split-Path (Split-Path $flutterPath)
    $bundledJava = Join-Path $flutterDir "bin\cache\artifacts\engine\windows-x64\flutter_tester.exe"
    
    # Check for bundled Java in Flutter
    $possibleJavaPaths = @(
        "$env:FLUTTER_ROOT\bin\cache\artifacts\engine\windows-x64",
        "$flutterDir\bin\cache\artifacts\engine\windows-x64"
    )
    
    foreach ($path in $possibleJavaPaths) {
        if (Test-Path $path) {
            Write-Host "Found Flutter directory: $path" -ForegroundColor Yellow
        }
    }
}

# Method 2: Check if Android Studio is installed (it includes Java)
$androidStudioPaths = @(
    "$env:LOCALAPPDATA\Android\Sdk\cmdline-tools\latest\bin",
    "$env:LOCALAPPDATA\Android\Sdk\tools\bin",
    "$env:ProgramFiles\Android\Android Studio\jre\bin",
    "$env:ProgramFiles\Android\Android Studio\jbr\bin"
)

$keytoolPath = $null
foreach ($path in $androidStudioPaths) {
    $keytoolExe = Join-Path $path "keytool.exe"
    if (Test-Path $keytoolExe) {
        $keytoolPath = $keytoolExe
        Write-Host "Found keytool at: $keytoolPath" -ForegroundColor Green
        break
    }
}

if (-not $keytoolPath) {
    # Try to find keytool in PATH
    $keytoolPath = (Get-Command keytool -ErrorAction SilentlyContinue).Source
}

if (-not $keytoolPath) {
    Write-Host "❌ Keytool not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install one of the following:" -ForegroundColor Yellow
    Write-Host "1. Java JDK: https://www.oracle.com/java/technologies/downloads/"
    Write-Host "2. Android Studio: https://developer.android.com/studio"
    Write-Host ""
    Write-Host "Alternative: Use this online SHA-1 generator:"
    Write-Host "1. Go to: https://developers.google.com/android/guides/client-auth"
    Write-Host "2. Use the default debug keystore values:"
    Write-Host "   - Keystore path: %USERPROFILE%\.android\debug.keystore"
    Write-Host "   - Keystore password: android"
    Write-Host "   - Key alias: androiddebugkey"
    Write-Host "   - Key password: android"
    Write-Host ""
    Read-Host "Press Enter to continue"
    exit 1
}

# Create .android directory if it doesn't exist
$androidDir = Join-Path $env:USERPROFILE ".android"
if (-not (Test-Path $androidDir)) {
    New-Item -ItemType Directory -Path $androidDir -Force | Out-Null
    Write-Host "Created .android directory" -ForegroundColor Yellow
}

# Check if debug keystore exists
$keystorePath = Join-Path $androidDir "debug.keystore"
if (-not (Test-Path $keystorePath)) {
    Write-Host "Creating debug keystore..." -ForegroundColor Yellow
    
    $createKeystoreCmd = @(
        "-genkey", "-v",
        "-keystore", "`"$keystorePath`"",
        "-storepass", "android",
        "-alias", "androiddebugkey",
        "-keypass", "android",
        "-keyalg", "RSA",
        "-keysize", "2048",
        "-validity", "10000",
        "-dname", "`"CN=Android Debug,O=Android,C=US`""
    )
    
    try {
        & $keytoolPath @createKeystoreCmd
        Write-Host "✅ Debug keystore created successfully!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to create keystore: $_" -ForegroundColor Red
        Read-Host "Press Enter to continue"
        exit 1
    }
}

# Extract SHA-1 fingerprint
Write-Host ""
Write-Host "Extracting SHA-1 fingerprint..." -ForegroundColor Yellow

$listKeystoreCmd = @(
    "-list", "-v",
    "-keystore", "`"$keystorePath`"",
    "-alias", "androiddebugkey",
    "-storepass", "android",
    "-keypass", "android"
)

try {
    $output = & $keytoolPath @listKeystoreCmd 2>&1
    $sha1Line = $output | Where-Object { $_ -match "SHA1:" }
    
    if ($sha1Line) {
        $sha1 = ($sha1Line -split "SHA1:")[1].Trim()
        Write-Host ""
        Write-Host "🔑 Your SHA-1 fingerprint is:" -ForegroundColor Green
        Write-Host $sha1 -ForegroundColor Cyan
        Write-Host ""
        
        # Copy to clipboard if possible
        try {
            $sha1 | Set-Clipboard
            Write-Host "✅ SHA-1 key copied to clipboard!" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  Could not copy to clipboard, please copy manually" -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ Could not extract SHA-1 fingerprint" -ForegroundColor Red
        Write-Host "Full output:" -ForegroundColor Yellow
        $output | ForEach-Object { Write-Host $_ }
    }
} catch {
    Write-Host "❌ Failed to read keystore: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Yellow
Write-Host "1. Go to Firebase Console: https://console.firebase.google.com"
Write-Host "2. Select your project"
Write-Host "3. Go to Project Settings (gear icon)"
Write-Host "4. Select your Android app"
Write-Host "5. Add the SHA-1 fingerprint above"
Write-Host "6. Download the updated google-services.json file"
Write-Host ""

Read-Host "Press Enter to continue"
