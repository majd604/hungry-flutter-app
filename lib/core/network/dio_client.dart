// ignore_for_file: unnecessary_null_comparison, avoid_types_as_parameter_names, non_constant_identifier_names, avoid_print

import 'package:dio/dio.dart';
import 'package:hungry/core/utils/pref_helper.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://sonic-zdi0.onrender.com/api",
      headers: {'Content-Type': 'application/json'},
    ),
  );

  DioClient() {
    // _dio.interceptors.add(
    //   LogInterceptor(requestBody: true, responseBody: true),
    // );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (Options, handler) async {
          final token = await PrefHelper.getToken();

          if (token != null && token.isNotEmpty && token != 'guest') {
            Options.headers['Authorization'] = 'Bearer $token';
          } else {}
          return handler.next(Options);
        },
      ),
    );
  }
  Dio get dio => _dio;
}
