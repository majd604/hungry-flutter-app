// ignore_for_file: unused_catch_clause, deprecated_member_use, unused_local_variable, body_might_complete_normally_nullable

import 'package:dio/dio.dart';
import 'package:hungry/core/network/api_error.dart';
import 'package:hungry/core/network/api_exceptions.dart';
import 'package:hungry/core/network/api_service.dart';
import 'package:hungry/core/utils/pref_helper.dart';
import 'package:hungry/features/auth/data/user_model.dart';

class AuthRepo {
  ApiService apiService = ApiService();
  bool isGuest = false;
  UserModel? _currentUser;
  //LOGIN
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiService.post("/login", {
        "email": email,
        "password": password,
      });
      if (response is ApiError) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final data = response['data'];

        if (code != 200 && code != 201) {
          throw ApiError(message: msg ?? "Unknown Error");
        }
        final user = UserModel.fromJson(response['data']);
        if (user.token != null) {
          await PrefHelper.saveToken(user.token!);
        }
        isGuest = false;
        _currentUser = user;
        return user;
      } else {
        throw ApiError(message: "UnExpected Error From Server");
      }
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  //SignUp
  Future<UserModel?> signup(String name, String email, String password) async {
    try {
      final response = await apiService.post('/register', {
        "name": name,
        "email": email,
        "password": password,
      });
      if (response is ApiError) {
        throw response;
      }
      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final coder = int.tryParse(code);
        final data = response['data'];
        if (coder != 200 && coder != 201) {
          throw ApiError(message: msg ?? "Unknown Error");
        }
        final user = UserModel.fromJson(response['data']);
        if (user.token != null) {
          await PrefHelper.saveToken(user.token!);
        }
        isGuest = false;
        _currentUser = user;
        return user;
      } else {
        throw ApiError(message: "UnExpected Error From Server");
      }
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  //Get Profile Data
  Future<UserModel?> getProfileData() async {
    try {
      final token = await PrefHelper.getToken();
      if (token == null || token == 'guest') {
        return null;
      }
      final response = await apiService.get('/profile');
      final user = UserModel.fromJson(response['data']);
      _currentUser = user;
      return user;
    } on DioError catch (e) {
      ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  //update profile
  Future<UserModel?> updateProfile({
    required String name,
    required String email,
    required String address,
    String? imagePath,
    String? visa,
  }) async {
    try {
      final formData = FormData.fromMap({
        "name": name,
        "email": email,
        "address": address,
        if (imagePath != null && imagePath.isNotEmpty)
          "image": await MultipartFile.fromFile(
            imagePath,
            filename: "profile.jpg",
          ),
        if (visa != null && visa.isNotEmpty) "Visa": visa,
      });

      final response = await apiService.post('/update-profile', formData);

      if (response is ApiError) {
        throw response;
      }

      if (response is Map<String, dynamic>) {
        final msg = response['message'];
        final code = response['code'];
        final data = response['data'] as Map<String, dynamic>?;

        // نحول الكود لـ int بشكل آمن
        final int? coder = code is int ? code : int.tryParse(code.toString());

        if (coder != null && coder != 200 && coder != 201) {
          throw ApiError(message: msg ?? "Unknown Error");
        }

        if (data == null) {
          throw ApiError(message: "No user data returned from server");
        }

        // 👈 هون كان الغلط، لازم نستعمل data نفسها مش response[data]
        final updateUser = UserModel.fromJson(data);
        _currentUser = updateUser;
        return updateUser;
      } else {
        throw ApiError(message: "UnExpected Error From Server");
      }
    } on DioError catch (e) {
      // خليه يرجع ApiError حقيقي
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  //logout
  Future<void> logout() async {
    final response = await apiService.post('/logout', {});
    if (response['data'] != null) {
      throw ApiError(message: "Logout Failed");
    }
    await PrefHelper.clearToken();
    _currentUser = null;
    isGuest = true;
  }

  //Auto Login
  Future<UserModel?> autoLogin() async {
    final token = await PrefHelper.getToken();
    if (token == null || token == 'guest') {
      isGuest = true;
      _currentUser = null;
      return null;
    }
    isGuest = false;
    try {
      final user = await getProfileData();
      _currentUser = user;
      return user;
    } catch (_) {
      await PrefHelper.clearToken();
      isGuest = true;
      _currentUser = null;
      return null;
    }
  }

  //continue as guest
  Future<void> continueAsGuest() async {
    isGuest = true;
    _currentUser = null;
    await PrefHelper.saveToken('guest');
  }

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => !isGuest && _currentUser != null;
}
