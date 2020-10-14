import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/app/models/menu_item_model.dart';
import 'package:pizza_delivery_app/app/models/user_model.dart';
import 'package:pizza_delivery_app/app/repositories/orders_repository.dart';
import 'package:pizza_delivery_app/app/view_models/checkout_input_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCardController extends ChangeNotifier {
  UserModel user;
  Set<MenuItemModel> itemsSelected = {};
  String _address = '';
  String _paymentType = '';
  String _error = '';
  bool _success = false;
  bool _loading = false;

  OrdersRepository _repository = OrdersRepository();

  String get paymentType => _paymentType;
  String get address => _address;
  String get error => _error;
  bool get success => _success;
  bool get loading => _loading;

  Future<void> loadPage() async {
    _error = null;
    _success = false;
    _loading = true;
    notifyListeners();
    final sp = await SharedPreferences.getInstance();
    user = UserModel.fromJson(sp.getString('user'));
    _loading = false;
    notifyListeners();
  }

  bool itemSelected(MenuItemModel item) => itemsSelected.contains(item);
  bool get hasItemSelected => itemsSelected.length > 0;
  double get totalPrice =>
      itemsSelected.fold(0.0, (total, item) => total += item.price);

  void addOrRemoveItem(MenuItemModel item) {
    if (itemSelected(item)) {
      _removeItemShoppingCard(item);
    } else {
      _addItemShoppingCard(item);
    }
    notifyListeners();
  }

  void _addItemShoppingCard(MenuItemModel item) async {
    itemsSelected.add(item);
    notifyListeners();
  }

  void _removeItemShoppingCard(MenuItemModel item) async {
    itemsSelected.remove(item);
    notifyListeners();
  }

  void clearShoppingCard() {
    itemsSelected.clear();
    _address = '';
    _paymentType = '';
    _loading = false;
    _error = null;
    notifyListeners();
  }

  void changeAddress(String newAddress) {
    _address = newAddress;
    _error = null;
    notifyListeners();
  }

  void changePaymentType(String newPaymentType) {
    _error = null;
    _paymentType = newPaymentType;
    notifyListeners();
  }

  Future<void> checkout() async {
    _error = null;
    _success = false;

    if (address == '') {
      _error = 'Direccion de entrega requerida';
      notifyListeners();
    } else if (paymentType == '') {
      _error = 'Tipo de pago obligatorio';
      notifyListeners();
    } else {
      String paymentTypeBackend = '';
      switch (paymentType) {
        case 'Tarjeta de Credito':
          paymentTypeBackend = 'Credito';
          break;
        case 'Tarjeta de Debito':
          paymentTypeBackend = 'Debito';
          break;
        case 'Efectivo':
          paymentTypeBackend = 'Dinheiro';
          break;
      }

      try {
        _loading = true;
        notifyListeners();
        await _repository.checkout(CheckoutInputModel(
          userId: user.id,
          address: address,
          paymentType: paymentTypeBackend,
          itemsId: itemsSelected.map((i) => i.id).toList(),
        ));
        _success = true;
      } catch (e) {
        print(e);
        _error = 'Error al registrar pedido';
      } finally {
        _loading = false;
        notifyListeners();
      }
    }
  }
}
