import 'package:shop_lite/features/auth/data/auth_api_service.dart';

class AuthRepository {
  final AuthApiService api;

  AuthRepository(this.api);

  Future<Map<String, dynamic>> login(String username, String password) async {
    final data = await api.login(username, password);

    return data['accessToken'];
  }
}
