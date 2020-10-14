import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum UserLogged {
  authenticate,
  unauthenticate,
}

class SplashController extends ChangeNotifier {
  UserLogged logged;

  Future<void> checkLogin() async {
    final sp = await SharedPreferences.getInstance();
    // sp.clear();
    if (sp.containsKey('user')) {
      logged = UserLogged.authenticate;
    } else {
      logged = UserLogged.unauthenticate;
    }

    notifyListeners();
  }
}
