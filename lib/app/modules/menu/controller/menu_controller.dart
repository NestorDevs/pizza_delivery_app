import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/app/models/menu_model.dart';
import 'package:pizza_delivery_app/app/repositories/menu_repository.dart';

class MenuController extends ChangeNotifier {
  MenuRepository _repository = MenuRepository();
  List<MenuModel> menu = [];

  bool loading = false;
  String error;

  Future<void> findMenu() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      menu = await _repository.findAll();
    } catch (e) {
      print(e);
      error = 'Error al buscar grupo';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
