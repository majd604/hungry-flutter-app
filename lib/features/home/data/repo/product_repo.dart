// ignore_for_file: prefer_final_fields, avoid_print

import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/features/home/data/models/product_model.dart';
import 'package:hungry/features/home/data/models/toppings_model.dart';

class ProductRepo {
  ApiService _apiService = ApiService();

  //get products

  Future<List<ProductModel>> getProdects() async {
    try {
      final response = await _apiService.get('/products');
      return (response['data'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //get Toppings
  Future<List<ToppingsModel>> gettoppings() async {
    try {
      final response = await _apiService.get('/toppings');
      return (response['data'] as List)
          .map((topping) => ToppingsModel.fromJson(topping))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //get Options
  Future<List<ToppingsModel>> getOptions() async {
    try {
      final response = await _apiService.get('/side-options');
      return (response['data'] as List)
          .map((topping) => ToppingsModel.fromJson(topping))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //search

  Future<List<ProductModel>> searchProduct(String name) async {
    final response = await _apiService.get('/products', param: {'name': name});
    try {
      return (response['data'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  //gategory
}
