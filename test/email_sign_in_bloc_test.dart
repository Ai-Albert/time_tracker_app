import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:time_tracker/app/sign_in/business_logic/email_sign_in_bloc.dart';
import 'package:time_tracker/app/sign_in/old/email_sign_in_model.dart';
import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  EmailSignInBloc bloc;

  setUp(() {
    mockAuth = MockAuth();
    bloc = EmailSignInBloc(auth: mockAuth);
  });

  tearDown(() {
    bloc.dispose();
  });

  test('WHEN email is updated'
      'AND password is updated'
      'AND submit is called'
      'THEN modelStream emits the correct events', () async {
    when(mockAuth.signInEmail(any, any))
        .thenThrow(PlatformException(code: 'ERROR'));

    // Expectation will wait for the stream to emit the models before finishing the test so we put
    // it in the beginning since BehaviorSubject can only evaluate the latest stream object, so
    // not after both models have been emitted
    expect(bloc.modelStream, emitsInOrder([
      EmailSignInModel(),
      EmailSignInModel(email: 'email@email.com'),
      EmailSignInModel(email: 'email@email.com', password: 'password'),
      EmailSignInModel(email: 'email@email.com', password: 'password', isLoading: true, submitted: true),
      EmailSignInModel(email: 'email@email.com', password: 'password', isLoading: false, submitted: true),
    ]));

    expect(bloc.modelStream, emits(EmailSignInModel()));

    bloc.updateEmail('email@email.com');

    bloc.updatePassword('password');

    try {
      await bloc.submit();
    } catch (_) {}
  });
}