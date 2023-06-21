import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_estoque/src/atualizar_onu/entities/atualizar_onu.dart';
import 'package:http/http.dart' as http;
import 'package:app_estoque/src/shared/settings/const_configs.dart';

class AtualizarOnuRepository {
  static const String _apiBasePath = ConstConfigs.apiUrl;
  static const String _authTokenKey = 'auth_token';
  final _storage = const FlutterSecureStorage();

  Future<bool> update(AtualizarOnu onu) async {
    final payload = {
      "tipo_onu_estoque": onu.tipo_onu_estoque,
      "motivo_entrega": onu.motivo_entrega,
      "desc_estoque": onu.desc_estoque,
      "nome_responsavel": onu.nome_responsavel
    };

    final response = await http.put(
      Uri.parse(
        '$_apiBasePath/api/serial/${onu.id}',
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
