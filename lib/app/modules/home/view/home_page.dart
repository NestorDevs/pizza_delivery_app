import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:pizza_delivery_app/app/modules/home/controller/home_controller.dart';
import 'package:pizza_delivery_app/app/modules/menu/controller/menu_controller.dart';
import 'package:pizza_delivery_app/app/modules/menu/view/menu_page.dart';
import 'package:pizza_delivery_app/app/modules/my_orders/controller/my_orders_controller.dart';
import 'package:pizza_delivery_app/app/modules/my_orders/view/my_orders_page.dart';
import 'package:pizza_delivery_app/app/modules/shopping_cart/controller/shopping_card_controller.dart';
import 'package:pizza_delivery_app/app/modules/shopping_cart/view/shopping_card_page.dart';
import 'package:pizza_delivery_app/app/modules/splash/view/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  static const router = '/home';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeController(),
      child: HomeContent(),
    );
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with SingleTickerProviderStateMixin {
  HomeController controller;

  final _tabSelected = ValueNotifier<int>(0);
  final _titles = [
    'Menu',
    'Mis Pedidos',
    'Carro de Compra',
    'Configuraciones',
  ];

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();
    controller.tabController = TabController(vsync: this, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: _tabSelected,
          builder: (_, _tabSelectedValue, child) {
            return Text(_titles[_tabSelectedValue]);
          },
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: controller.bottomNavigationKey,
        backgroundColor: Colors.white,
        color: Theme.of(context).primaryColor,
        buttonBackgroundColor: Colors.white,
        items: [
          Image.asset(
            'assets/images/logo.png',
            width: 30,
          ),
          Icon(FontAwesome.list),
          Icon(Icons.shopping_cart),
          Icon(Icons.menu),
        ],
        onTap: (index) {
          _tabSelected.value = index;
          controller.tabController.animateTo(index);
        },
      ),
      body: SafeArea(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => MenuController()..findMenu()),
            ChangeNotifierProvider(create: (_) => MyOrdersController()),
            ChangeNotifierProvider(create: (_) => ShoppingCardController()),
          ],
          child: TabBarView(
            controller: controller.tabController,
            children: [
              MenuPage(),
              MyOrdersPage(),
              ShoppingCardPage(),
              FlatButton(
                child: Text(
                  'Salir',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  final sp = await SharedPreferences.getInstance();
                  sp.clear();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      SplashPage.router, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
