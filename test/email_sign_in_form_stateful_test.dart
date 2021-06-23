import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/old/email_sign_in_form_stateful.dart';
import 'package:time_tracker/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

class MockUser extends Mock implements User {}

void main() {
  MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: EmailSignInFormStateful(onSignedIn: onSignedIn),
          ),
        ),
      ),
    );
  }

  void stubSignInEmailSucceeds() {
    when(mockAuth.signInEmail(any, any))
        .thenAnswer((_) => Future<User>.value(MockUser()));
  }

  void stubSignInEmailFails() {
    when(mockAuth.signInEmail(any, any))
        .thenThrow(FirebaseAuthException(code: 'ERROR_WRONG_PASSWORD'));
  }

  group('sign in', () {
    testWidgets(
        'WHEN user doesn\'t enter the email and password'
        'AND user taps on the sign-in button'
        'THEN signInEmail is not called'
        'AND user is not signed in', (WidgetTester tester) async {
      bool signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      verifyNever(mockAuth.signInEmail(any, any));
      expect(signedIn, false);
    });

    testWidgets(
        'WHEN user enters the email and password'
        'AND user taps on the sign-in button'
        'THEN signInEmail is called'
        'AND user is signed in', (WidgetTester tester) async {
      bool signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);
      stubSignInEmailSucceeds();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.pump(); // This rebuilds the widgets since they don't auto update in tests

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);
      // 1 is the number of times we expect this method to be called
      verify(mockAuth.signInEmail(email, password)).called(1);
      expect(signedIn, true);
    });

    testWidgets(
        'WHEN user enters the email and password'
        'AND user taps on the sign-in button'
        'THEN signInEmail is called'
        'AND user is signed in', (WidgetTester tester) async {
      bool signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);
      stubSignInEmailFails();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.pump();

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);
      // 1 is the number of times we expect this method to be called
      verify(mockAuth.signInEmail(email, password)).called(1);
      expect(signedIn, false);
    });
  });

  group('register', () {
    testWidgets(
        'WHEN user taps on the secondary button'
        'THEN form toggles to registration mode', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final switchButton = find.text('Need an account? Register');
      await tester.tap(switchButton);
      await tester.pump();

      final registerButton = find.text('Create an account');
      expect(registerButton, findsOneWidget);
    });

    testWidgets(
        'WHEN user taps on the secondary button'
        'AND user enters the email and password'
        'AND user taps on the register button'
        'THEN createUserEmail is called', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final switchButton = find.text('Need an account? Register');
      await tester.tap(switchButton);
      await tester.pump();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.pump();

      final registerButton = find.text('Create an account');
      await tester.tap(registerButton);
      // 1 is the number of times we expect this method to be called
      verify(mockAuth.createUserEmail(email, password)).called(1);
    });
  });
}
