import 'package:dio/dio.dart';
import 'package:pizza_delivery_app/app/exceptions/rest_exception.dart';
import 'package:pizza_delivery_app/app/models/menu_model.dart';

class MenuRepository {
  Future<List<MenuModel>> findAll() async {
    try {
      final response = await Dio().get('http://192.168.42.120:8888/menu');
      return response.data.map<MenuModel>((m) => MenuModel.fromMap(m)).toList();
    } on DioError catch (e) {
      print(e);
      throw RestException('Error al buscar cardapio');
    }
  }
}
