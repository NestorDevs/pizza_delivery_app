import 'package:flutter/material.dart';

import 'app/modules/auth/view/login_page.dart';
import 'app/modules/auth/view/register_page.dart';
import 'app/modules/home/view/home_page.dart';
import 'app/modules/menu/view/menu_page.dart';
import 'app/modules/shopping_cart/view/shopping_card_page.dart';
import 'app/modules/splash/view/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pizza Delivery',
      theme: ThemeData(
        primaryColor: Color(0XFF9D0000),
        primarySwatch: Colors.red,
      ),
      initialRoute: SplashPage.router,
      routes: {
        SplashPage.router: (_) => SplashPage(),
        LoginPage.router: (_) => LoginPage(),
        RegisterPage.router: (_) => RegisterPage(),
        HomePage.router: (_) => HomePage(),
        MenuPage.router: (_) => MenuPage(),
        ShoppingCardPage.router: (_) => ShoppingCardPage(),
      },
    );
  }
}
