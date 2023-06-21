import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_estoque/src/cadastrar_onu/entities/cadastrar_onu.dart';
import 'package:http/http.dart' as http;
import 'package:app_estoque/src/shared/settings/const_configs.dart';

class CadastrarOnuRepository {
  static const String _apiBasePath = ConstConfigs.apiUrl;
  static const String _authTokenKey = 'auth_token';
  final _storage = const FlutterSecureStorage();

  Future<bool> store(CadastrarOnu onu) async {
    final payload = {
      "tipo_onu_estoque": onu.tipo_onu_estoque,
      "serial_estoque": "prks00" + onu.serial_estoque,
      "motivo_entrega": onu.motivo_entrega,
      "desc_estoque": onu.desc_estoque,
      "nome_responsavel": onu.nome_responsavel,
      "user": onu.user,
    };

    final response = await http.post(
      Uri.parse(
        '$_apiBasePath/api/serial',
      ),
      body: jsonEncode(payload),
      headers: await _header(),
    );

    return response.statusCode != 201;
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
