import 'package:dio/dio.dart';
import 'package:pizza_delivery_app/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery_app/app/models/order_model.dart';
import 'package:pizza_delivery_app/app/view_models/checkout_input_model.dart';

class OrdersRepository {
  Future<List<OrderModel>> findByMyOrders(int userId) async {
    try {
      final result =
          await Dio().get('http://192.168.42.120:8888/orders/user/$userId');

      return result.data.map<OrderModel>((o) => OrderModel.fromMap(o)).toList();
    } on DioError catch (e) {
      print(e);
      throw RestException('Error al buscar pedido');
    }
  }

  Future<void> checkout(CheckoutInputModel inputModel) async {
    try {
      await Dio()
          .post('http://192.168.42.120:8888/order', data: inputModel.toJson());
    } on DioError catch (e) {
      print(e);
      throw RestException('Error al registrar pedido');
    }
  }
}
