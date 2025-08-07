import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import '../services/auth_service.dart';

class FirebaseTest {
  static final AuthService _authService = AuthService();

  /// Test Firebase connection and configuration
  static Future<Map<String, dynamic>> testFirebaseSetup() async {
    Map<String, dynamic> results = {
      'platform_supported': false,
      'firebase_initialized': false,
      'auth_available': false,
      'google_signin_available': false,
      'errors': <String>[],
      'warnings': <String>[],
    };

    try {
      // Check platform support
      if (!kIsWeb && (defaultTargetPlatform == TargetPlatform.android || 
                      defaultTargetPlatform == TargetPlatform.iOS)) {
        results['platform_supported'] = true;
        
        // Check if Firebase is initialized
        try {
          final apps = Firebase.apps;
          if (apps.isNotEmpty) {
            results['firebase_initialized'] = true;
            results['auth_available'] = _authService.isFirebaseAvailable;
            
            // Test authentication service
            try {
              final authState = _authService.authStateChanges;
              results['google_signin_available'] = true;
            } catch (e) {
              results['errors'].add('Auth service error: $e');
            }
          } else {
            results['errors'].add('Firebase not initialized');
          }
        } catch (e) {
          results['errors'].add('Firebase initialization error: $e');
        }
      } else {
        results['warnings'].add('Firebase only supported on Android/iOS');
      }
    } catch (e) {
      results['errors'].add('General error: $e');
    }

    return results;
  }

  /// Test email authentication
  static Future<Map<String, dynamic>> testEmailAuth(String email, String password) async {
    Map<String, dynamic> results = {
      'success': false,
      'error': null,
      'user_created': false,
    };

    try {
      if (!_authService.isFirebaseAvailable) {
        results['error'] = 'Firebase not available on this platform';
        return results;
      }

      // Try to create account
      final userCredential = await _authService.registerWithEmailAndPassword(
        email, 
        password, 
        'Test User'
      );
      
      if (userCredential != null) {
        results['success'] = true;
        results['user_created'] = true;
        
        // Sign out after test
        await _authService.signOut();
      }
    } catch (e) {
      results['error'] = e.toString();
    }

    return results;
  }

  /// Test Google Sign-In
  static Future<Map<String, dynamic>> testGoogleSignIn() async {
    Map<String, dynamic> results = {
      'success': false,
      'error': null,
      'user_signed_in': false,
    };

    try {
      if (!_authService.isFirebaseAvailable) {
        results['error'] = 'Firebase not available on this platform';
        return results;
      }

      // Try Google Sign-In
      final userCredential = await _authService.signInWithGoogle();
      
      if (userCredential != null) {
        results['success'] = true;
        results['user_signed_in'] = true;
        
        // Sign out after test
        await _authService.signOut();
      } else {
        results['error'] = 'User cancelled sign-in';
      }
    } catch (e) {
      results['error'] = e.toString();
    }

    return results;
  }

  /// Generate a comprehensive test report
  static Future<String> generateTestReport() async {
    final setupResults = await testFirebaseSetup();
    
    StringBuffer report = StringBuffer();
    report.writeln('🔥 Firebase Setup Test Report');
    report.writeln('=' * 40);
    report.writeln();
    
    // Platform Support
    report.writeln('📱 Platform Support:');
    report.writeln('  Supported: ${setupResults['platform_supported'] ? '✅' : '❌'}');
    if (!setupResults['platform_supported']) {
      report.writeln('  Note: Firebase only works on Android/iOS');
    }
    report.writeln();
    
    // Firebase Status
    report.writeln('🔥 Firebase Status:');
    report.writeln('  Initialized: ${setupResults['firebase_initialized'] ? '✅' : '❌'}');
    report.writeln('  Auth Available: ${setupResults['auth_available'] ? '✅' : '❌'}');
    report.writeln('  Google Sign-In: ${setupResults['google_signin_available'] ? '✅' : '❌'}');
    report.writeln();
    
    // Errors
    if (setupResults['errors'].isNotEmpty) {
      report.writeln('❌ Errors:');
      for (String error in setupResults['errors']) {
        report.writeln('  • $error');
      }
      report.writeln();
    }
    
    // Warnings
    if (setupResults['warnings'].isNotEmpty) {
      report.writeln('⚠️  Warnings:');
      for (String warning in setupResults['warnings']) {
        report.writeln('  • $warning');
      }
      report.writeln();
    }
    
    // Recommendations
    report.writeln('💡 Next Steps:');
    if (!setupResults['platform_supported']) {
      report.writeln('  • Test on Android/iOS device for full functionality');
    } else if (!setupResults['firebase_initialized']) {
      report.writeln('  • Check google-services.json file placement');
      report.writeln('  • Verify Firebase project configuration');
    } else if (setupResults['errors'].isEmpty) {
      report.writeln('  • ✅ Setup looks good! Try authentication features');
    }
    
    return report.toString();
  }
}
