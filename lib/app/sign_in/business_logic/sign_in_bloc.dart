import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInAnon() async => await _signIn(auth.signInAnonymously);

  Future<User> signInGoogle() async => await _signIn(auth.signInGoogle);

  Future<User> signInFB() async => await _signIn(auth.signInFB);
}