// ignore_for_file: deprecated_member_use, avoid_print

import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioError error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    if (statusCode != null) {
      if (data is Map<String, dynamic> && data['message'] != null) {
        return ApiError(message: data['message'], statusCode: statusCode);
      }
    }
    if (statusCode == 302) {
      throw ApiError(message: "Email already exists");
    }
    switch (error.type) {
      case DioErrorType.connectionTimeout:
        return ApiError(message: "Connection Timeout, Please try again");
      case DioErrorType.sendTimeout:
        return ApiError(message: "Request Timeout, Please try again");
      case DioErrorType.receiveTimeout:
        return ApiError(message: "Response Timeout, Please try again");
      default:
        return ApiError(
          message: "An unexpected error occurred, Please try again",
        );
    }
  }
}
