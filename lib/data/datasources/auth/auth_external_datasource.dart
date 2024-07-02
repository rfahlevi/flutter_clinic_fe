import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_clinic/data/datasources/auth/auth_local_datasource.dart';
import 'package:flutter_clinic/data/repositories/auth/auth_repository.dart';
import 'package:flutter_clinic/domain/entities/result.dart';
import 'package:flutter_clinic/domain/entities/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthExternalDatasource implements AuthRepository {
  final Dio _dio;

  AuthExternalDatasource({Dio? dio}) : _dio = dio ?? Dio();

  String baseUrl = dotenv.get('BASE_URL');

  @override
  Future<Result<User>> login({required String email, required String password}) async {
    try {
      String apiUrl = '$baseUrl/login';
      log(apiUrl);

      var response = await _dio.post(apiUrl,
          data: FormData.fromMap({
            'email': email,
            'password': password,
          }),
          options: Options(headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          }));

      log('$response');

      var result = response.data;

      if (result['status'] == true) {
        await AuthLocalDatasource().saveToken(result['token']);
        return Result.success(
          User.fromJson(
            result['data'],
          ),
        );
      } else {
        return Result.failed(result['message']);
      }
    } on DioException catch (e) {
      log(e.error.toString());
      return Result.failed(e.response?.data['message'] ?? 'Internal Server Error');
    }
  }

  @override
  Future<Result<User>> getUser() async {
    try {
      String apiUrl = '$baseUrl/user';
      String? token = await AuthLocalDatasource().getToken();

      var response = await _dio.get(apiUrl,
          options: Options(headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          }));

      var result = response.data;

      if (response.statusCode == 200) {
        await AuthLocalDatasource().saveAuthData(User.fromJson(result));
        return Result.success(User.fromJson(
          result,
        ));
      } else {
        await AuthLocalDatasource().removeAuthData();
        await AuthLocalDatasource().removeToken();
        return Result.failed(response.statusMessage ?? 'Internal Server Error');
      }
    } on DioException catch (e) {
      await AuthLocalDatasource().removeAuthData();
      await AuthLocalDatasource().removeToken();
      return Result.failed(e.response?.data['message'] ?? 'Internal Server Error');
    }
  }

  @override
  Future<Result<String>> logout() async {
    try {
      String apiUrl = '$baseUrl/logout';
      String? token = await AuthLocalDatasource().getToken();

      var response = await _dio.post(
        apiUrl,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      var result = response.data;

      if (result['status'] == true) {
        await AuthLocalDatasource().removeAuthData();
        await AuthLocalDatasource().removeToken();
        return Result.success(result['message']);
      } else {
        return Result.failed(result['message']);
      }
    } on DioException catch (e) {
      return Result.failed(e.response?.data['message'] ?? 'Internal Server Error');
    }
  }
}
