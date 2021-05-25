import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobs/add_job_page.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';
import '../models/job.dart';

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => AddJobPage.show(context),
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs.map((job) => Text(job.name)).toList();
          return ListView(children: children);
        }
        if (snapshot.hasError) {
          return Center(child: Text('Some error occurred'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
