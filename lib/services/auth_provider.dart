import 'package:flutter/widgets.dart';
import 'auth.dart';

class AuthProvider extends InheritedWidget {

  final AuthBase auth;
  final Widget child;

  AuthProvider({this.auth, this.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  static AuthBase of(BuildContext context) {
    AuthProvider provider = context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    return provider.auth;
  }
}