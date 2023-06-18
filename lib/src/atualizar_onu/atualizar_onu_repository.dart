import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_estoque/src/atualizar_onu/entities/atualizar_onu.dart';
import 'package:http/http.dart' as http;
import 'package:app_estoque/src/shared/settings/const_configs.dart';

class AtualizarOnuRepository {
  static const String _apiBasePath = ConstConfigs.apiUrl;
  static const String _authTokenKey = 'auth_token';
  final _storage = const FlutterSecureStorage();

  Future<List<AtualizarOnu>> index(AtualizarOnu id) async {
    final response = await http.get(
      Uri.parse(
        "$_apiBasePath/api/serial/3",
      ),
      headers: await _header(),
    );

    final responseJson = jsonDecode(response.body);
    print(responseJson);
    List<AtualizarOnu> output = [];

    output.add(AtualizarOnu.fromJson(responseJson));

    return output;
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
