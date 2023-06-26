import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:app_estoque/src/shared/settings/const_configs.dart';
import 'package:http/http.dart' as http;

class ReportsRepository {
  static const String _authTokenKey = 'auth_token';
  static const String _apiBasePath = ConstConfigs.apiUrl;
  final _storage = const FlutterSecureStorage();

  Future<List<quantPorTipo>> quantPorTipoMes(int year) async {
    final response = await http.get(
      Uri.parse(
        '$_apiBasePath/api/serial_painel/quantPorTipo/$year',
      ),
      headers: await _header(),
    );

    if (response.statusCode != 200) {
      throw Exception("Falha ao buscar o relatório.");
    }

    var mapedResponse = jsonDecode(response.body);

    List<quantPorTipo> output = [];
    for (var i = 0; i < mapedResponse.length; i++) {
      output.add(
        quantPorTipo(
          classification: mapedResponse[i]["tipo_onu_estoque"] ?? "default",
          total: mapedResponse[i]["total"],
        ),
      );
    }

    return output;
  }

  Future<List<AmountPerMonth>> amountPerMonth(int year) async {
    final response = await http.get(
      Uri.parse(
        '$_apiBasePath/api/serial_painel/quantMes/$year',
      ),
      headers: await _header(),
    );

    if (response.statusCode != 200) {
      throw Exception("Falha ao buscar o relatório.");
    }

    var mapedResponse = jsonDecode(response.body);

    List<AmountPerMonth> output = [];
    for (var i = 0; i < mapedResponse.length; i++) {
      output.add(
        AmountPerMonth(
          month: mapedResponse[i]["month"],
          total: mapedResponse[i]["total"],
        ),
      );
    }

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

class quantPorTipo {
  final String classification;
  final int total;

  quantPorTipo({required this.classification, required this.total});

  @override
  String toString() {
    return "Classificação: $classification; Total: $total";
  }
}

class AmountPerMonth {
  final String month;
  final int total;

  AmountPerMonth({required this.month, required this.total});

  @override
  String toString() {
    return "Mês: $month; Total: $total";
  }
}

class AmountPerSchool {
  final String school;
  final int total;

  AmountPerSchool({required this.school, required this.total});

  @override
  String toString() {
    return "Escola: $school; Total: $total";
  }
}
