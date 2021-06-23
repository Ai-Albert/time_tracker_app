import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in.dart';
import 'package:time_tracker/app/sign_in/business_logic/sign_in_bloc.dart';
import 'package:time_tracker/common_widgets/sign_in_button.dart';
import 'package:time_tracker/common_widgets/social_sign_in_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.bloc, @required this.isLoading}) : super(key: key);
  final SignInBloc bloc;
  final bool isLoading;

  static const Key emailKey = Key('email');

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInBloc>(
          create: (_) => SignInBloc(auth: auth, isLoading: isLoading),
          child: Consumer<SignInBloc>(
            builder: (_, bloc, __) => SignInPage(bloc: bloc, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException && exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future _signInAnon(BuildContext context) async {
    try {
      await bloc.signInAnon();
    } catch (e) {
      _showSignInError(context, e);
    }
  }

  Future _signInGoogle(BuildContext context) async {
    try {
      await bloc.signInGoogle();
    } catch (e) {
      _showSignInError(context, e);
    }
  }

  Future _signInFB(BuildContext context) async {
    try {
      await bloc.signInFB();
    } catch (e) {
      _showSignInError(context, e);
    }
  }

  void _signInEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 50.0, child: _buildHeader(isLoading)),
          SizedBox(height: 48.0),

          // Buttons start below
          SocialSignInButton(
            image: 'google-logo.png',
            text: 'Sign in with Google',
            color: Colors.white,
            textColor: Colors.black87,
            onPressed: !isLoading ? () => _signInGoogle(context) : null,
          ),
          SizedBox(height: 8.0),

          SocialSignInButton(
            image: 'facebook-logo.png',
            text: 'Sign in with Facebook',
            color: Color(0xFF334D92),
            textColor: Colors.white,
            onPressed: !isLoading ? () => _signInFB(context) : null,
          ),
          SizedBox(height: 8.0),

          SignInButton(
            key: emailKey,
            text: 'Sign in with email',
            color: Colors.teal[700],
            textColor: Colors.white,
            onPressed: !isLoading ? () => _signInEmail(context) : null,
          ),
          SizedBox(height: 8.0),

          Text(
            'or',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),

          SignInButton(
            text: 'Go anonymous',
            color: Colors.lime[300],
            textColor: Colors.black,
            onPressed: !isLoading ? () => _signInAnon(context) : null,
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}