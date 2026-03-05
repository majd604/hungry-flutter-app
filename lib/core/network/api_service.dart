// ignore_for_file: unused_catch_clause, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/core/network/dio_client.dart';

class ApiService {
  final DioClient _dioClient = DioClient();
  //CURD METHODS

  //GET
  Future<dynamic> get(String endPoint, {dynamic param}) async {
    try {
      final response = await _dioClient.dio.get(
        endPoint,
        queryParameters: param,
      );
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  //POST
  Future<dynamic> post(String endPoint, dynamic body) async {
    try {
      final response = await _dioClient.dio.post(endPoint, data: body);
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  //PUT-UPDATE
  Future<dynamic> put(String endPoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.put(endPoint, data: body);
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  //DELETE
  Future<dynamic> delete(
    String endPoint,
    Map<String, dynamic> body, {
    dynamic params,
  }) async {
    try {
      final response = await _dioClient.dio.delete(
        endPoint,
        data: body,
        queryParameters: params,
      );
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleError(e);
    }
  }
}
