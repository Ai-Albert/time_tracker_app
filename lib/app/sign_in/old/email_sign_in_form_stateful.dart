import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'email_sign_in_model.dart';

class EmailSignInFormStateful extends StatefulWidget {
  @override
  _EmailSignInFormStatefulState createState() => _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful>
    with EmailAndPasswordValidators {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  bool _submitted = false;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _loading = true;
    });
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await Provider.of<AuthBase>(context, listen: false).signInEmail(_email, _password);
      } else {
        await Provider.of<AuthBase>(context, listen: false).createUserEmail(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _changeForm() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  void _updateState() {
    setState(() {});
  }

  List<Widget> _buildChildren() {
    final String primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final String secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    bool emailValid = emailValidator.isValid(_email);
    bool passwordValid = passwordValidator.isValid(_password);
    bool submitEnabled = !_loading && emailValid && passwordValid;
    bool showEmailError = _submitted && !emailValid;
    bool showPasswordError = _submitted && !passwordValid;

    return [
      TextField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showEmailError ? 'Email can\'t be empty' : null,
        ),
        enabled: !_loading,
        controller: _emailController,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: (email) => _updateState(),
      ),
      SizedBox(height: 8.0),
      TextField(
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: showPasswordError ? 'Password can\'t be empty' : null,
        ),
        enabled: !_loading,
        obscureText: true,
        controller: _passwordController,
        autocorrect: false,
        textInputAction: TextInputAction.done,
        onChanged: (password) => _updateState(),
      ),
      SizedBox(height: 8.0),
      ElevatedButton(
        child: Text(primaryText),
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0),
      TextButton(
        child: Text(secondaryText),
        onPressed: !_loading ? _changeForm : null,
      ),
    ];
  }
}
