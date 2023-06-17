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
      pageTitle: 'Pesquise aqui o Serial de uma ONU',
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

    void onPressedSubmit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        //imprime no console os dados.
        //print("Serial ONU: " + serial.text);

        PesquisarOnuRepository().index(PesquisarOnu(
          serial_estoque: serial.text,
        ));

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Onu recebida com sucesso!')));

        //print("Retorne a lista: ${suaFuncao()}");
      }
    }

    formWidget.add(
      Container(
        margin: const EdgeInsets.only(top: 25),
        child: ElevatedButton(
          onPressed:
              onPressedSubmit, // Chama o método onPressedSubmit e envia os dados para o repository
          child: const Text(
            'Enviar',
          ),
        ),
      ),
    );

    return formWidget;
  }
}
