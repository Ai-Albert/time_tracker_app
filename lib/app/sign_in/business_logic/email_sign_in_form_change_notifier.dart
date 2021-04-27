import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/business_logic/email_sign_in_bloc.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  const EmailSignInFormChangeNotifier({Key key, @required this.model}) : super(key: key);
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (_) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (_, model, __) => EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() => _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _changeForm() {
    model.changeForm();
    _emailController.clear();
    _passwordController.clear();
  }

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

  List<Widget> _buildChildren() {
    bool emailValid = model.emailValidator.isValid(model.email);
    bool passwordValid = model.passwordValidator.isValid(model.password);
    bool submitEnabled = !model.isLoading && emailValid && passwordValid;
    bool showEmailError = model.submitted && !emailValid;
    bool showPasswordError = model.submitted && !passwordValid;

    return [
      TextField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showEmailError ? 'Email can\'t be empty' : null,
        ),
        enabled: !model.isLoading,
        controller: _emailController,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onChanged: model.updateEmail,
      ),
      SizedBox(height: 8.0),
      TextField(
        decoration: InputDecoration(
          labelText: 'Password',
          errorText: showPasswordError ? 'Password can\'t be empty' : null,
        ),
        enabled: !model.isLoading,
        obscureText: true,
        controller: _passwordController,
        autocorrect: false,
        textInputAction: TextInputAction.done,
        onChanged: model.updatePassword,
      ),
      SizedBox(height: 8.0),
      ElevatedButton(
        child: Text(model.primaryButtonText),
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0),
      TextButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? _changeForm : null,
      ),
    ];
  }
}
