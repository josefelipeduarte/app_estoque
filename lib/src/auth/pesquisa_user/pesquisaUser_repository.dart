import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_estoque/src/pesquisar_onu/entities/pesquisar_onu.dart';
import 'package:http/http.dart' as http;
import 'package:app_estoque/src/shared/settings/const_configs.dart';

class PesquisarUserRepository {
  static const String _apiBasePath = ConstConfigs.apiUrl;
  static const String _authTokenKey = 'auth_token';
  final _storage = const FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> index() async {
    final response = await http.get(
      Uri.parse(
        "$_apiBasePath/api/auth/listar",
      ),
      headers: await _header(),
    );

    final responseJson = jsonDecode(response.body);

    List<Map<String, dynamic>> itemList = [];
    for (var i = 0; i < responseJson.length; i++) {
      itemList.add({
        "id": responseJson[i]["id"],
        "name": responseJson[i]["name"],
        "email": responseJson[i]["email"],
        "is_admin": responseJson[i]["is_admin"],
      });
    }

    return itemList;
  }

  Future<void> deleteUser(int parsedId) async {
    final response = await http.delete(
      Uri.parse("$_apiBasePath/api/auth/deletar/$parsedId"),
      headers: await _header(),
    );

    if (response.statusCode == 200) {
      // Deleção bem-sucedida
      print('Usuário deletado com sucesso');
    } else {
      // Erro na deleção
      print('Erro ao deletar usuário: ${response.statusCode}');
    }
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
