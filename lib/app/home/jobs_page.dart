import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class JobsPage extends StatelessWidget {

  Future _signOut(BuildContext context) async {
    try {
      await Provider.of<AuthBase>(context, listen: false).signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> _confirmSignOut(BuildContext context) async {
    final request = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to log out?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (request == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
