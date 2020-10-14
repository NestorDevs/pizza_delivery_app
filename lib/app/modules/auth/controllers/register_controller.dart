import 'package:flutter/material.dart';
import 'package:pizza_delivery_app/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery_app/app/repositories/auth_repository.dart';
import 'package:pizza_delivery_app/app/view_models/register_input_model.dart';

class RegisterController extends ChangeNotifier {
  bool loading;
  bool registerSuccess;
  String error;
  final AuthRepository _repository = AuthRepository();

  Future<void> registerUser(String name, String email, String password) async {
    loading = true;
    registerSuccess = false;
    notifyListeners();
    final inputModel = RegisterInputModel(
      name: name,
      email: email,
      password: password,
    );

    try {
      await _repository.saveUser(inputModel);
      registerSuccess = true;
    } on RestException catch (e) {
      registerSuccess = false;
      error = e.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
