import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in.dart';
import 'package:time_tracker/app/sign_in/sign_in_button.dart';
import 'package:time_tracker/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool _loading = false;

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
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<AuthBase>(context, listen: false).signInAnonymously();
    } catch (e) {
      _showSignInError(context, e);
    }
    finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future _signInGoogle(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<AuthBase>(context, listen: false).signInGoogle();
    } catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future _signInFB(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    try {
      await Provider.of<AuthBase>(context, listen: false).signInFB();
    } catch (e) {
      _showSignInError(context, e);
    } finally {
      setState(() {
        _loading = false;
      });
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
          SizedBox(height: 50.0, child: _buildHeader()),
          SizedBox(height: 48.0),

          // Buttons start below
          SocialSignInButton(
            image: 'google-logo.png',
            text: 'Sign in with Google',
            color: Colors.white,
            textColor: Colors.black87,
            onPressed: !_loading ? () => _signInGoogle(context) : null,
          ),
          SizedBox(height: 8.0),

          SocialSignInButton(
            image: 'facebook-logo.png',
            text: 'Sign in with Facebook',
            color: Color(0xFF334D92),
            textColor: Colors.white,
            onPressed: !_loading ? () => _signInFB(context) : null,
          ),
          SizedBox(height: 8.0),

          SignInButton(
            text: 'Sign in with email',
            color: Colors.teal[700],
            textColor: Colors.white,
            onPressed: !_loading ? () => _signInEmail(context) : null,
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
            onPressed: !_loading ? () => _signInAnon(context) : null,
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (_loading) {
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