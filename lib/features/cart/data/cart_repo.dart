// cart_repo.dart
// ignore_for_file: use_rethrow_when_possible, avoid_print, body_might_complete_normally_nullable

import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/features/cart/data/cart_model.dart';

class CartRepo {
  final ApiService _apiService = ApiService();

  //Add To Cart

  Future<void> addToCart(CartRequestModel cartData) async {
    try {
      final res = await _apiService.post('/cart/add', cartData.toJson());

      // لو ApiService رجّع ApiError مباشرة
      if (res is ApiError) {
        throw res;
      }

      // لو رجّع Map من السيرفر
      if (res is Map<String, dynamic>) {
        final int? code = res['code'] as int?;
        final String? msg = res['message'] as String?;

        // أي كود غير 200 / 201 نعتبره خطأ
        if (code != null && code != 200 && code != 201) {
          throw ApiError(message: msg ?? 'Error while adding to cart');
        }

        // كود 200 أو 201 => نجاح ✅
        return;
      }

      // لو إجا نوع غريب
      throw ApiError(message: 'Unexpected response from server');
    } catch (e) {
      if (e is ApiError) {
        // خليه يطلع كما هو
        throw e;
      }
      throw ApiError(message: e.toString());
    }
  }

  //GetCard
  Future<GetCartResponse?> getCardData() async {
    try {
      final res = await _apiService.get('/cart');
      if (res is ApiError) {
        throw ApiError(message: res.message);
      }
      return GetCartResponse.fromJson(res);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  //deleteCartIteams

  Future<void> removeCartIteams(int id) async {
    try {
      final res = await _apiService.delete('/cart/remove/$id', {});
      if (res['code'] == 200 && res['data'] == null) {
        throw ApiError(message: res['message']);
      }
    } catch (e) {
      throw ApiError(message: "Remove Iteams From Cart :${e.toString()}");
    }
  }
}
