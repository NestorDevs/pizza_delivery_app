import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:pizza_delivery_app/app/models/menu_item_model.dart';
import 'package:pizza_delivery_app/app/modules/home/controller/home_controller.dart';
import 'package:pizza_delivery_app/app/modules/menu/controller/menu_controller.dart';
import 'package:pizza_delivery_app/app/modules/shopping_cart/controller/shopping_card_controller.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class MenuPage extends StatelessWidget {
  static const router = '/menu';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<ShoppingCardController>(
        builder: (_, controller, __) {
          if (controller.hasItemSelected) {
            return FloatingActionButton.extended(
              icon: Icon(Icons.monetization_on),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                context.read<HomeController>().changeTab(2);
              },
              label: Text('Finaliza el Pedido'),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildMenu(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 350,
          child: Stack(
            children: [
              Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.none,
                    image: AssetImage('assets/images/topoCardapio.png'),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildMenu(BuildContext context) {
    return Consumer<MenuController>(
      builder: (_, controller, __) {
        if (controller.loading) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (!isNull(controller.error)) {
          return Text(controller.error);
        }
        var menu = controller.menu;
        return Column(children: [
          ...menu.map<Widget>((m) {
            return _buildGroup(context, m.name, m.items);
          }).toList(),
          SizedBox(height: 50),
        ]);
      },
    );
  }

  Widget _buildGroup(
      BuildContext context, String name, List<MenuItemModel> items) {
    var formater = NumberFormat('###.00', 'pt_br');
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          child: Text(
            name,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (context, index) {
            var mi = items[index];
            return ListTile(
                title: Text(
                  mi.name,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('R\$ ${formater.format(mi.price)}'),
                trailing: Consumer<ShoppingCardController>(
                  builder: (_, controllerShoppingCard, __) {
                    final itemSelected =
                        controllerShoppingCard.itemSelected(mi);
                    return IconButton(
                      icon: Icon(
                        itemSelected
                            ? FontAwesome.minus_square
                            : FontAwesome.plus_square,
                        color: Theme.of(context).primaryColor,
                        size: 20,
                      ),
                      onPressed: () =>
                          controllerShoppingCard.addOrRemoveItem(mi),
                    );
                  },
                ));
          },
        ),
      ],
    );
  }
}
