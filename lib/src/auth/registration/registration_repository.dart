import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_estoque/src/auth/registration/entities/registration.dart';
import 'package:http/http.dart' as http;
import 'package:app_estoque/src/shared/settings/const_configs.dart';

class RegistrationRepository {
  static const String _apiBasePath = ConstConfigs.apiUrl;
  static const String _authTokenKey = 'auth_token';

  final _storage = const FlutterSecureStorage();

  // pra esse retorno é preciso alterar a versão mínima do 3.0.0
  Future<({bool error, String reason})> store(Registration registration) async {
    final payload = {
      "name": registration.name,
      "password": registration.password,
      "email": registration.email,
      "is_admin": registration.admin,
    };

    final response = await http.post(
      Uri.parse('$_apiBasePath/api/auth/registrar'),
      body: jsonEncode(payload),
      headers: await _header(),
    );

    return (
      error: response.statusCode != 201,
      reason: "Falha ao cadastrar o usuário."
    );
  }

  Future<Map<String, String>> _header() async {
    String? authToken = await _storage.read(key: _authTokenKey);

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  }
}
