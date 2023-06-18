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
        child: SignUpPesquisarOnu(),
      ),
    );
  }
}

class SignUpPesquisarOnu extends StatefulWidget {
  const SignUpPesquisarOnu({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpPesquisarOnu> {
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
            hintText: 'Digite aqui',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Não deixe o campo vazio';
            }
            return null;
          },
        ),
      ),
    );
    void onPressedSubmit() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();

        itemList = await PesquisarOnuRepository().index(PesquisarOnu(
          serial_estoque: serial.text,
        ));

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Serial enviado para pesquisa.')));
      }
      print(itemList);
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

        return ListTile(
          title: Text('ID: ${item['id']}'),
          subtitle: Text('Serial: ${item['serial_estoque']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Implemente a lógica para a ação de deletar o item com o ID correspondente
                  String id = item['id'].toString();
                  print("Item $id deletado com sucesso");
                },
                child: Text('Deletar'),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Implemente a lógica para a ação de editar o item com o ID correspondente
                  String id = item['id'].toString();
                  print("Item $id editado com sucesso");
                },
                child: Text('Editar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
