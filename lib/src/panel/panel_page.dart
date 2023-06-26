import 'package:flutter/material.dart';
import 'package:app_estoque/src/panel/repositories/reports_repository.dart';
import 'package:app_estoque/src/shared/components/app_scaffold.dart';

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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageTitle: "Painel",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
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
            TableTipo(
              apcWidgetList: apcWidgetList,
            ),
            const SizedBox(height: 8),
            const Text(
              "Quantidade Recebida por Mês",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TablePerPeriod(apmWidgetList: apmWidgetList),
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
