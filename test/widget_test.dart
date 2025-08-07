// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pro_test/main.dart';

void main() {
  testWidgets('Hope Out app loads splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HopeOutApp());

    // Verify that the splash screen loads with the app name
    expect(find.text('Hope Out'), findsOneWidget);
    expect(find.text('Connect • Play • Grow Together'), findsOneWidget);

    // Verify the community icon is present
    expect(find.byIcon(Icons.groups), findsOneWidget);

    // Verify loading indicator is present
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the timer to complete and navigate to next screen
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // On desktop platforms, should show login screen
    // On mobile platforms with Firebase, would show auth wrapper
    expect(find.text('Welcome to Hope Out'), findsOneWidget);
  });

  testWidgets('Login screen shows platform message on desktop', (WidgetTester tester) async {
    await tester.pumpWidget(const HopeOutApp());

    // Wait for splash screen to complete
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Try to tap login button (should show platform error on desktop)
    final loginButton = find.text('Sign In');
    if (loginButton.evaluate().isNotEmpty) {
      await tester.tap(loginButton);
      await tester.pump();

      // Should show error message about platform support
      expect(find.textContaining('mobile platforms'), findsOneWidget);
    }
  });
}
