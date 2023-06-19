import 'package:app_estoque/src/atualizar_onu/atualizar_onuu_page.dart';
import 'package:app_estoque/src/pesquisar_onu/entities/pesquisar_onu.dart';
import 'package:app_estoque/src/pesquisar_onu/pesquisar_onu_repository.dart';
import 'package:flutter/material.dart';
import 'package:app_estoque/src/shared/components/app_scaffold.dart';
import 'package:app_estoque/src/auth/auth_service.dart';
import 'package:provider/provider.dart';

class PesquisarOnuPage extends StatefulWidget {
  const PesquisarOnuPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<PesquisarOnuPage> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      pageTitle: 'Pesquisar ONU',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SerialPesquisarOnu(),
      ),
    );
  }
}

class SerialPesquisarOnu extends StatefulWidget {
  const SerialPesquisarOnu({super.key});

  @override
  _SerialFormState createState() => _SerialFormState();
}

class _SerialFormState extends State<SerialPesquisarOnu> {
  final _formKey = GlobalKey<FormState>();

  //gera Controller para coletar dados do serial
  final serial = TextEditingController();
  List<Map<String, dynamic>> itemList = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: getFormWidget(),
      ),
    );
  }

  void updateItemList() {
    setState(() {
      itemList = itemList;
    });
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = [];

    formWidget.add(
      Container(
        margin: const EdgeInsets.only(top: 35),
        child: Row(
          children: const [
            Icon(Icons.key),
            SizedBox(width: 8),
            Text(
              'Serial Da ONU',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
    formWidget.add(
      Container(
        margin: const EdgeInsets.only(top: 12),
        child: TextFormField(
          controller: serial,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: const InputDecoration(
            hintText: 'Digite aqui ex. c12345',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Digite o Serial ex. c63123';
            }
            if (value.length != 6) {
              return 'O Serial deve ter exatamente 6 caracteres exemplo: c61234';
            }
            return null;
          },
        ),
      ),
    );
    void onPressedSubmit() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        // ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Serial enviado para pesquisa.')));
        itemList = await PesquisarOnuRepository().index(PesquisarOnu(
          serial_estoque: serial.text,
        ));

        if (itemList.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nada foi encontrado.')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Opa achamos algo!')));
        }
      }

      print(itemList);
      //da um set State na lista pra ela ser apresentada no site.
      setState(() {
        updateItemList();
      });
    }

    formWidget.add(
      Container(
        margin: const EdgeInsets.only(top: 25),
        child: ElevatedButton(
          onPressed:
              onPressedSubmit, // Chama o método onPressedSubmit e envia os dados para o repository
          child: const Text(
            'Enviar',
            style: TextStyle(
              color: Colors.white, // Defina a cor do texto como branca
            ),
          ),

          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            backgroundColor: const Color.fromARGB(
                255, 0, 81, 255), // Defina a cor de fundo desejada
          ),
        ),
      ),
    );

    //apresenta a lista de seriais
    formWidget.add(
      ItemListWidget(itemList: itemList),
    );

    return formWidget;
  }
}

class ItemListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> itemList;

  const ItemListWidget({required this.itemList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        final item = itemList[index];

        editOnu(item) {
          var estoqueId = item['id'].toString();
          var serialEstoque = item['serial_estoque'].toString();
          var tipoOnu = item['tipo_onu_estoque'].toString();
          var motivoEntrega = item['motivo_entrega'].toString();
          var descEstoque = item['motivo_entrega'].toString();
          var nomeResponsavel = item['nome_responsavel'].toString();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditUser(
                        estoqueId: estoqueId,
                        serialEstoque: serialEstoque,
                        tipoOnu: tipoOnu,
                        motivoEntrega: motivoEntrega,
                        descEstoque: descEstoque,
                        nomeResponsavel: nomeResponsavel,
                      )));
        }

        deleteUser(item) async {
          String id = item['id'].toString();
          int parsedId = int.parse(id);

          await PesquisarOnuRepository().deleteSerial(parsedId);
        }

        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${item['id']}'),
              Text('Serial: ${item['serial_estoque']}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirmação'),
                        content: Text('Tem certeza que deseja excluir o item?'),
                        actions: [
                          TextButton(
                            child: Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop(); // Fechar o diálogo
                            },
                          ),
                          TextButton.icon(
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.red), // Cor do ícone e texto
                            ),
                            onPressed: () async {
                              deleteUser(item);
                              Navigator.of(context).pop(); // Fechar o diálogo
                            },
                            icon: Icon(Icons.delete), // Ícone de lixeira
                            label: Text('Deletar',
                                style: TextStyle(
                                    color: Colors
                                        .red)), // Texto "Deletar" com cor vermelha
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete),
                label: Text('Deletar'),
              ),
              SizedBox(width: 4),
              ElevatedButton(
                onPressed: () {
                  editOnu(item);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 0, 81, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 4),
                    Text('Editar'),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
