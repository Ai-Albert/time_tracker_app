import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});
  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    } finally {
      _setIsLoading(false);
    }
  }

  Future<User> signInAnon() async => await _signIn(auth.signInAnonymously);

  Future<User> signInGoogle() async => await _signIn(auth.signInGoogle);

  Future<User> signInFB() async => await _signIn(auth.signInFB);
}