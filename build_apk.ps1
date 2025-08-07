# PowerShell script to build APK for Hope Out app
Write-Host "🚀 Building Hope Out APK for Android..." -ForegroundColor Green
Write-Host ""

# Function to check if running as administrator
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check for administrator privileges
if (-not (Test-Administrator)) {
    Write-Host "⚠️  Requesting administrator privileges..." -ForegroundColor Yellow
    Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "✅ Running with administrator privileges" -ForegroundColor Green
Write-Host ""

try {
    # Step 1: Clean project
    Write-Host "🧹 Step 1: Cleaning project..." -ForegroundColor Cyan
    $cleanResult = & flutter clean 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "⚠️  Clean had issues, but continuing..." -ForegroundColor Yellow
    } else {
        Write-Host "✅ Project cleaned successfully" -ForegroundColor Green
    }
    Write-Host ""

    # Step 2: Get dependencies
    Write-Host "📦 Step 2: Getting dependencies..." -ForegroundColor Cyan
    & flutter pub get
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to get dependencies"
    }
    Write-Host "✅ Dependencies downloaded successfully" -ForegroundColor Green
    Write-Host ""

    # Step 3: Build APK
    Write-Host "🔨 Step 3: Building APK (this may take several minutes)..." -ForegroundColor Cyan
    Write-Host "Please wait while Flutter compiles your app..." -ForegroundColor Yellow
    
    $buildStart = Get-Date
    & flutter build apk --debug --verbose
    $buildEnd = Get-Date
    $buildTime = $buildEnd - $buildStart
    
    if ($LASTEXITCODE -ne 0) {
        throw "APK build failed"
    }

    # Check if APK was created
    $apkPath = "build\app\outputs\flutter-apk\app-debug.apk"
    if (Test-Path $apkPath) {
        $apkSize = (Get-Item $apkPath).Length
        $apkSizeMB = [math]::Round($apkSize / 1MB, 2)
        
        Write-Host ""
        Write-Host "🎉 APK built successfully!" -ForegroundColor Green
        Write-Host "📍 Location: $apkPath" -ForegroundColor Cyan
        Write-Host "📏 Size: $apkSizeMB MB" -ForegroundColor Cyan
        Write-Host "⏱️  Build time: $($buildTime.Minutes)m $($buildTime.Seconds)s" -ForegroundColor Cyan
        Write-Host ""
        
        Write-Host "📱 To install on your Android device:" -ForegroundColor Yellow
        Write-Host "1. Copy app-debug.apk to your phone (via USB, email, or cloud)" -ForegroundColor White
        Write-Host "2. On your phone, go to Settings → Security → Enable 'Unknown sources'" -ForegroundColor White
        Write-Host "3. Tap the APK file on your phone to install" -ForegroundColor White
        Write-Host "4. You may see a warning - tap 'Install anyway'" -ForegroundColor White
        Write-Host ""
        
        Write-Host "🔧 For Firebase testing:" -ForegroundColor Yellow
        Write-Host "1. Complete Firebase Console setup first" -ForegroundColor White
        Write-Host "2. Replace google-services.json with the one from Firebase" -ForegroundColor White
        Write-Host "3. Rebuild APK after Firebase setup" -ForegroundColor White
        Write-Host ""
        
        # Open APK folder
        Write-Host "📂 Opening APK folder..." -ForegroundColor Cyan
        Start-Process "explorer.exe" -ArgumentList "build\app\outputs\flutter-apk\"
        
    } else {
        throw "APK file not found after build"
    }

} catch {
    Write-Host ""
    Write-Host "❌ Build failed: $_" -ForegroundColor Red
    Write-Host ""
    Write-Host "🛠️  Troubleshooting steps:" -ForegroundColor Yellow
    Write-Host "1. Make sure Android SDK is installed" -ForegroundColor White
    Write-Host "2. Check available disk space (need ~2GB free)" -ForegroundColor White
    Write-Host "3. Close antivirus software temporarily" -ForegroundColor White
    Write-Host "4. Try running: flutter doctor" -ForegroundColor White
    Write-Host "5. Restart your computer and try again" -ForegroundColor White
}

Write-Host ""
Write-Host "Press any key to continue..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
