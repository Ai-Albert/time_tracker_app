import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker/common_widgets/show_alert_dialog.dart';

Future showExceptionAlertDialog(
  BuildContext context, {
  @required String title,
  @required Exception exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content: exception.toString(),
      defaultActionText: 'OK',
    );

String _message(Exception exception) {
    if (exception is FirebaseException) {
        return exception.message;
    }
    return exception.toString();
}