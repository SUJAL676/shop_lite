import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String token,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'refresh_token', value: token);
  }

  Future<void> saveUserCred({
    required String userName,
    required String firstName,
    required String lastName,
    required String email,
    required String photo,
    required String gender,
  }) async {
    await _storage.write(key: 'user_username', value: userName);
    await _storage.write(key: 'user_firstname', value: firstName);
    await _storage.write(key: 'user_lastname', value: lastName);
    await _storage.write(key: 'user_email', value: email);
    await _storage.write(key: 'user_photourl', value: photo);
    await _storage.write(key: 'user_gender', value: gender);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }

  Future<Map> getUserCred() async {
    Map user = {};

    var name = await _storage.read(key: 'user_username');
    var photo = await _storage.read(key: 'user_photourl');

    user.addAll({"user_name": name, "user_photo": photo});

    return user;
  }
}
