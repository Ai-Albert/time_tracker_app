import 'package:flutter/material.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_form.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignIn extends StatelessWidget {

  final AuthBase auth;
  const EmailSignIn({Key key, @required this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm(auth: auth),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
