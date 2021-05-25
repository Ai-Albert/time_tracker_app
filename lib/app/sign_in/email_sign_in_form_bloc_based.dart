import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/business_logic/email_sign_in_bloc.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'old/email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  const EmailSignInFormBlocBased({Key key, @required this.bloc}) : super(key: key);
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormBlocBasedState createState() => _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
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
    widget.bloc.changeForm();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChildren(model),
          ),
        );
      },
    );
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
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
        onChanged: widget.bloc.updateEmail,
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
        onChanged: widget.bloc.updatePassword,
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
