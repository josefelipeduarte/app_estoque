import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_estoque/src/pesquisar_onu/entities/pesquisar_onu.dart';
import 'package:http/http.dart' as http;
import 'package:app_estoque/src/shared/settings/const_configs.dart';

class PesquisarOnuRepository {
  static const String _apiBasePath = ConstConfigs.apiUrl;
  static const String _authTokenKey = 'auth_token';
  final _storage = const FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> index(PesquisarOnu seriali) async {
    final response = await http.get(
      Uri.parse(
        "$_apiBasePath/api/serial/pesquisar/${seriali.serial_estoque}",
      ),
      headers: await _header(),
    );

    final responseJson = jsonDecode(response.body);

    List<Map<String, dynamic>> itemList = [];
    for (var i = 0; i < responseJson.length; i++) {
      itemList.add({
        "id": responseJson[i]["id"],
        "serial_estoque": responseJson[i]["serial_estoque"],
      });
    }
    print(itemList);
    return itemList;
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
