import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:time_tracker/app/sign_in/business_logic/sign_in_bloc.dart';
import 'mocks.dart';

class MockValueNotifier<T> extends ValueNotifier<T> {
  MockValueNotifier(T value) : super(value);

  List<T> values = [];

  @override
  set value(T newValue) {
    values.add(newValue);
    super.value = newValue;
  }
}

void main() {
  MockAuth mockAuth;
  MockValueNotifier<bool> isLoading;
  SignInBloc bloc;

  setUp(() {
    mockAuth = MockAuth();
    isLoading = MockValueNotifier<bool>(false);
    bloc = SignInBloc(auth: mockAuth, isLoading: isLoading);
  });

  test('sign in - success', () async {
    when(mockAuth.signInAnonymously())
        .thenAnswer((_) => Future.value(MockUser.uid('uid')));
    await bloc.signInAnon();
    expect(isLoading.values, [true]);
  });

  test('sign in - failure', () async {
    when(mockAuth.signInAnonymously())
        .thenThrow(PlatformException(code: 'ERROR', message: 'sign-in failed'));

    // We're telling Flutter to throw an exception so to go to expect() we have to put it in catch
    try {
      await bloc.signInAnon();
    } catch(e) {
      expect(isLoading.values, [true, false]);
    }
  });
}