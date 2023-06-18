import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_estoque/src/atualizar_onu/entities/atualizar_onu.dart';
import 'package:http/http.dart' as http;
import 'package:app_estoque/src/shared/settings/const_configs.dart';

class AtualizarOnuRepository {
  static const String _apiBasePath = ConstConfigs.apiUrl;
  static const String _authTokenKey = 'auth_token';
  final _storage = const FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> index(AtualizarOnu identification) async {
    final response = await http.get(
      Uri.parse(
        "$_apiBasePath/api/serial/${identification.id}",
      ),
      headers: await _header(),
    );

    final responseJson = jsonDecode(response.body);
    List<Map<String, dynamic>> itemList = [];

    if (responseJson != null) {
      var item = responseJson;

      var tipoOnuEstoque = item["tipo_onu_estoque"];
      var serialEstoque = item["serial_estoque"];
      var motivoEntrega = item["motivo_entrega"];
      var descEstoque = item["desc_estoque"];
      var nomeResponsavel = item["nome_responsavel"];

      itemList.add({
        "tipo_onu_estoque": tipoOnuEstoque,
        "serial_estoque": serialEstoque,
        "motivo_entrega": motivoEntrega,
        "desc_estoque": descEstoque,
        "nome_responsavel": nomeResponsavel,
      });
    } else {
      print("Consulta Nula. Nada gravado.");
    }

    print(itemList[0]["serial_estoque"]);
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
