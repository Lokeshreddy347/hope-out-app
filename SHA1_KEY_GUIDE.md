# 🔑 SHA-1 Key for Firebase - Quick Setup Guide

## 🚀 Quick Solution (Use Default Debug Key)

For development and testing, you can use the **default debug SHA-1 key** that Flutter uses:

```
SHA1: 58:E1:C5:71:7A:1A:8E:78:00:00:51:4D:D2:6A:89:A5:C8:E5:8F:BA
```

### ✅ Steps to Add This to Firebase:

1. **Go to Firebase Console**: https://console.firebase.google.com
2. **Select your project** (or create a new one)
3. **Click the gear icon** → **Project Settings**
4. **Select your Android app** (or add a new Android app)
   - Package name: `com.example.flutter_pro_test`
   - App nickname: `Hope Out`
5. **Scroll down to "SHA certificate fingerprints"**
6. **Click "Add fingerprint"**
7. **Paste the SHA-1 key**: `58:E1:C5:71:7A:1A:8E:78:00:00:51:4D:D2:6A:89:A5:C8:E5:8F:BA`
8. **Download the updated google-services.json**
9. **Replace** your current `android/app/google-services.json` with the new one

## 🛠️ Alternative: Install Java to Generate Your Own Key

If you want to generate your own SHA-1 key:

### Option 1: Install Java JDK
1. **Download Java JDK**: https://www.oracle.com/java/technologies/downloads/
2. **Install Java** and add it to your PATH
3. **Run the script**: `.\get_sha_key.ps1`

### Option 2: Install Android Studio (Recommended)
1. **Download Android Studio**: https://developer.android.com/studio
2. **Install Android Studio** (includes Java and Android SDK)
3. **Run the script**: `.\get_sha_key.ps1`

## 🔧 Enable Authentication in Firebase

After adding the SHA-1 key:

1. **Go to Authentication** → **Sign-in method**
2. **Enable Email/Password**:
   - Click on "Email/Password"
   - Toggle "Enable"
   - Click "Save"

3. **Enable Google Sign-In**:
   - Click on "Google"
   - Toggle "Enable"
   - Add your support email
   - Click "Save"

## 🧪 Test Your Setup

After completing the Firebase setup:

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Run on Windows for testing
flutter run -d windows

# Or build for Android
flutter build apk --debug
```

## 📱 What You'll See

1. **Splash Screen** → **Login Screen**
2. **Try Email Registration**: Create a new account
3. **Try Google Sign-In**: Sign in with Google (requires proper SHA-1 setup)
4. **Home Dashboard**: Welcome screen with your name

## ⚠️ Important Notes

- **Default SHA-1 key** works for development/testing
- **For production**, generate your own SHA-1 key
- **Google Sign-In** requires the correct SHA-1 key
- **Email/Password** works without SHA-1 key

## 🆘 Troubleshooting

### Google Sign-In Not Working?
- Verify SHA-1 key is added to Firebase
- Check google-services.json is updated
- Ensure package name matches: `com.example.flutter_pro_test`

### Build Errors?
- Run `flutter clean`
- Run `flutter pub get`
- Enable Developer Mode in Windows

### Still Having Issues?
- Use Email/Password authentication (works without SHA-1)
- Check Firebase Console for error logs
- Verify internet connection

## 🎯 Quick Start Commands

```bash
# 1. Clean project
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Run app
flutter run -d windows
```

Your Firebase authentication is ready to use! 🚀
