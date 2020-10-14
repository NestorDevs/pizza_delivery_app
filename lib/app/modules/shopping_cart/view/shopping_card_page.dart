import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:intl/intl.dart';
import 'package:pizza_delivery_app/app/modules/home/controller/home_controller.dart';
import 'package:pizza_delivery_app/app/modules/shopping_cart/components/shopping_card_item.dart';
import 'package:pizza_delivery_app/app/modules/shopping_cart/controller/shopping_card_controller.dart';
import 'package:pizza_delivery_app/app/shared/components/pizza_delivery_button.dart';
import 'package:pizza_delivery_app/app/shared/mixins/loader_mixin.dart';
import 'package:pizza_delivery_app/app/shared/mixins/message_mixin.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class ShoppingCardPage extends StatefulWidget {
  static const router = '/shopping';

  @override
  _ShoppingCardPageState createState() => _ShoppingCardPageState();
}

class _ShoppingCardPageState extends State<ShoppingCardPage>
    with LoaderMixin, MessageMixin {
  final numberFormat = NumberFormat.currency(
    name: 'R\$',
    locale: 'pt_BR',
    decimalDigits: 2,
  );

  final addressEditingController = TextEditingController();
  final paymentTypeSelected = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final controller = context.read<ShoppingCardController>();
      controller.loadPage();
      controller.addListener(() async {
        if (this.mounted) {
          showHideLoaderHelper(context, controller.loading);

          if (!isNull(controller.error)) {
            showError(context: context, message: controller.error);
          }

          if (controller.success) {
            showSuccess(
                context: context, message: 'Pedido realizado con exito');
            Future.delayed(Duration(seconds: 1), () {
              controller.clearShoppingCard();
              context.read<HomeController>().changeTab(1);
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<ShoppingCardController>(
          builder: (_, controller, __) {
            return !controller.hasItemSelected
                ? _buildClearShoppingCard(context)
                : Column(
                    children: [
                      ListTile(
                        title: Text('Nombre'),
                        subtitle: Text(controller?.user?.name ?? ''),
                      ),
                      Divider(),
                      _buildShoppingCardItems(context, controller),
                      Divider(),
                      ListTile(
                        title: Text('Direccion de Entrega'),
                        subtitle: Text(controller.address ?? ''),
                        trailing: FlatButton(
                          onPressed: () => changeAddress(),
                          child: Text(
                            'Cambiar',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(
                        title: Text('Forma de Pago'),
                        subtitle: Text(controller.paymentType),
                        trailing: FlatButton(
                          onPressed: () => changePaymentType(),
                          child: Text(
                            'Cambiar',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Divider(),
                      // Expanded(child: Container()),
                      SizedBox(height: 20),
                      PizzaDeliveryButton(
                        'Finalizar Pedido',
                        width: MediaQuery.of(context).size.width * .8,
                        height: 50,
                        buttonColor: Theme.of(context).primaryColor,
                        labelSize: 18,
                        labelColor: Colors.white,
                        onPressed: () => controller.checkout(),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _buildShoppingCardItems(
      BuildContext context, ShoppingCardController controller) {
    final items = controller.itemsSelected.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            'Pedido',
            style: TextStyle(fontSize: 16),
          ),
        ),
        SizedBox(height: 10),
        ...items.map<ShoppingCardItem>((i) => ShoppingCardItem(i)).toList(),
        Divider(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total'),
              Text(numberFormat.format(controller.totalPrice)),
            ],
          ),
        ),
        FlatButton(
          onPressed: () => controller.clearShoppingCard(),
          child: Text(
            'Limpiar Carrito',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildClearShoppingCard(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            AntDesign.shoppingcart,
            size: 200,
          ),
          Text('No hay item seleccionados'),
        ],
      ),
    );
  }

  void changeAddress() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Direccion de Entrega'),
          content: TextField(
            controller: addressEditingController,
          ),
          actions: [
            RaisedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            RaisedButton(
              onPressed: () {
                context
                    .read<ShoppingCardController>()
                    .changeAddress(addressEditingController.text);
                Navigator.pop(context);
              },
              child: Text('Cambiar'),
            ),
          ],
        );
      },
    );
  }

  void changePaymentType() {
    showDialog(
      context: context,
      builder: (_) {
        final controller = context.read<ShoppingCardController>();
        paymentTypeSelected.value = controller.paymentType;

        return AlertDialog(
          title: Text('Tipo de Pago'),
          content: Container(
              height: 150,
              child: ValueListenableBuilder(
                valueListenable: paymentTypeSelected,
                builder: (_, paymentTypeSelectedValue, child) {
                  return RadioButtonGroup(
                    picked: paymentTypeSelectedValue,
                    labels: <String>[
                      'Tarjeta de Credito',
                      'Tarjeta de Debito',
                      'Efectivo',
                    ],
                    onSelected: (String selected) {
                      paymentTypeSelected.value = selected;
                    },
                  );
                },
              )),
          actions: [
            RaisedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar')),
            RaisedButton(
              onPressed: () {
                context
                    .read<ShoppingCardController>()
                    .changePaymentType(paymentTypeSelected.value);
                Navigator.pop(context);
              },
              child: Text('Cambiar'),
            ),
          ],
        );
      },
    );
  }
}
