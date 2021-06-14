import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_tracker/app/sign_in/old/email_sign_in_model.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInBloc {

  EmailSignInBloc({@required this.auth});

  final AuthBase auth;

  final _modelSubject = BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());
  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;
  EmailSignInModel get _model => _modelSubject.value;

  void dispose() {
    _modelSubject.close();
  }

  void changeForm() {
    updateWith(
      email: '',
      password: '',
      formType: _model.formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    // update model
    _modelSubject.value = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInEmail(_model.email, _model.password);
      } else {
        await auth.createUserEmail(_model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}