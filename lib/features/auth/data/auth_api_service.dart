import 'package:dio/dio.dart';

class AuthApiService {
  final Dio dio;

  AuthApiService(this.dio);

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await dio.post(
      'https://dummyjson.com/auth/login',
      data: {"username": username, "password": password},
    );

    return response.data;
  }
}
