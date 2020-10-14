import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/app/modules/auth/view/login_page.dart';
import 'package:pizza_delivery_app/app/modules/home/view/home_page.dart';
import 'package:pizza_delivery_app/app/modules/splash/controller/splash_controller.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  static const router = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => SplashController()..checkLogin(),
        child: SplashContent(),
      ),
    );
  }
}

class SplashContent extends StatefulWidget {
  @override
  _SplashContentState createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  @override
  void initState() {
    super.initState();
    var controller = context.read<SplashController>();
    controller.addListener(() {
      switch (controller.logged) {
        case UserLogged.authenticate:
          Navigator.of(context)
              .pushNamedAndRemoveUntil(HomePage.router, (route) => false);
          break;
        case UserLogged.unauthenticate:
          Navigator.of(context)
              .pushNamedAndRemoveUntil(LoginPage.router, (route) => false);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
