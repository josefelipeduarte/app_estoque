import 'package:app_estoque/src/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:app_estoque/src/panel/repositories/reports_repository.dart';
import 'package:app_estoque/src/shared/components/app_scaffold.dart';
import 'package:provider/provider.dart';

class PanelPage extends StatefulWidget {
  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  final ReportsRepository repository = ReportsRepository();
  final dropValue = ValueNotifier('');
  final currentYear = DateTime.now().year.toString();
  int selectedYear = DateTime.now().year;

  List<DataRow> apcWidgetList = [];
  List<DataRow> apmWidgetList = [];

  @override
  initState() {
    setState(() {
      apcWidgetList = [];
      apmWidgetList = [];

      repository.quantPorTipoMes(selectedYear).then((value) {
        setState(() {
          apcWidgetList = mapApcList(value);
        });
      });

      repository.amountPerMonth(selectedYear).then((value) {
        setState(() {
          apmWidgetList = mapApmList(value);
        });
      });
    });
  }

  List<int> getYearRange() {
    const int startYear = 2000;
    const int endYear = 2030;
    final List<int> yearList = [];

    for (int year = startYear; year <= endYear; year++) {
      yearList.add(year);
    }

    return yearList;
  }

  List<DataRow> mapApcList(List<quantPorTipo> amountPerClassificationList) {
    Map<String, String> tipos = {
      "101": "101",
      "411": "411",
      "501": "501",
    };

//Cria os quadradinhos com cores
    List<DataRow> output = [];
    for (var element in amountPerClassificationList) {
      output.add(
        DataRow(
          cells: <DataCell>[
            DataCell(
              Text(
                tipos[element.classification]!,
              ),
            ),
            DataCell(Text(element.total.toString())),
          ],
        ),
      );
    }

    return output;
  }

  List<DataRow> mapApmList(List<AmountPerMonth> amountsPerMonth) {
    List<DataRow> output = [];
    for (var element in amountsPerMonth) {
      output.add(
        DataRow(
          cells: <DataCell>[
            DataCell(Text(element.month)),
            DataCell(Text(element.total.toString())),
          ],
        ),
      );
    }

    return output;
  }

  String? usuarioAtivador;
  void getUser(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    usuarioAtivador = authService.user?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    getUser(context);
    return AppScaffold(
      pageTitle: "Inicio",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Seja bem vindo(a): ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: usuarioAtivador,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            const Row(
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Divider(
                    color: Colors.grey,
                    height: 1,
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Recebidas no Ano de:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton(
                  items: getYearRange().map((int dropDownStringItem) {
                    return DropdownMenuItem<int>(
                      value: dropDownStringItem,
                      child: Text(
                        dropDownStringItem.toString(),
                      ),
                    );
                  }).toList(),
                  value: selectedYear,
                  onChanged: (selected) {
                    setState(() {
                      apcWidgetList = [];
                      apmWidgetList = [];

                      selectedYear = selected!;
                      repository.quantPorTipoMes(selectedYear).then((value) {
                        setState(() {
                          apcWidgetList = mapApcList(value);
                        });
                      });

                      repository.amountPerMonth(selectedYear).then((value) {
                        setState(() {
                          apmWidgetList = mapApmList(value);
                        });
                      });
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Onu Por Tipo",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder(
              future: Future.delayed(
                  const Duration(seconds: 5)), // Aguarda 5 segundos
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Exibe o indicador de carregamento centralizado
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // Atraso concluído, exibe o child desejado
                  return TableTipo(apcWidgetList: apcWidgetList);
                }
              },
            ),
            const SizedBox(height: 8),
            const Text(
              "Quantidade Recebida por Mês",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            FutureBuilder(
              future: Future.delayed(
                  const Duration(seconds: 5)), // Aguarda 5 segundos
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Exibe o indicador de carregamento centralizado
                  return const Center(child: CircularProgressIndicator());
                } else {
                  // Atraso concluído, exibe o child desejado
                  return TablePerPeriod(apmWidgetList: apmWidgetList);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TableTipo extends StatelessWidget {
  List<DataRow> apcWidgetList;
  TableTipo({
    super.key,
    required this.apcWidgetList,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Modelo',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Quantidade',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: apcWidgetList,
    );
  }
}

class TablePerPeriod extends StatelessWidget {
  List<DataRow> apmWidgetList = [];
  TablePerPeriod({super.key, required this.apmWidgetList});

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Text(
              'Mês',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Quantidade',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ],
      rows: apmWidgetList,
    );
  }
}
