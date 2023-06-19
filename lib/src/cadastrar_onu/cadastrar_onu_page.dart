import 'package:app_estoque/src/cadastrar_onu/entities/cadastrar_onu.dart';
import 'package:app_estoque/src/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:app_estoque/src/cadastrar_onu/cadastrar_onu_repository.dart';
import 'package:app_estoque/src/shared/components/app_scaffold.dart';
import 'dart:async';

class CadastrarOnuPage extends StatefulWidget {
  const CadastrarOnuPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<CadastrarOnuPage> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      pageTitle: 'Cadastrar ONU Recebida',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SignUpCadastrarOnu(),
      ),
    );
  }
}

class SignUpCadastrarOnu extends StatefulWidget {
  const SignUpCadastrarOnu({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpCadastrarOnu> {
  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> modeloOnuList = [
    DropdownMenuItem(
      value: '501',
      child: Text('501'),
    ),
    DropdownMenuItem(
      value: '101',
      child: Text('101'),
    ),
    DropdownMenuItem(
      value: '411',
      child: Text('411'),
    ),
  ];
  List<DropdownMenuItem<String>> motivoList = [
    DropdownMenuItem(
      value: 'Apresenta Defeito',
      child: Text('Equipamento Apresenta Defeito'),
    ),
    DropdownMenuItem(
      value: 'Devolucao a Central',
      child: Text('Equipamento Devolvido a central'),
    ),
    DropdownMenuItem(
      value: 'Retirada',
      child: Text('Equipamento de Retirada'),
    ),
  ];
  List<DropdownMenuItem<String>> responsavelList = [
    DropdownMenuItem(
      value: 'Adriano',
      child: Text('Adriano'),
    ),
    DropdownMenuItem(
      value: 'Andreza',
      child: Text('Andreza'),
    ),
  ];

  //gera Controller para coletar dados da descrição.
  final descricao = TextEditingController();
  final serial = TextEditingController();

  String? selectedModel;
  String? selectedMotivo;
  String? selectedResponsavel;

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
      Row(
        children: const [
          Icon(Icons.all_inbox),
          SizedBox(width: 8),
          Text(
            'Modelo da ONU',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    formWidget.add(
      Container(
        margin: const EdgeInsets.only(top: 5),
        child: DropdownButtonFormField<String>(
          hint: const Text('Selecione o modelo'),
          items: modeloOnuList,
          onChanged: (value) {
            setState(() {
              selectedModel = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Selecione uma opção para continuar';
            }
            return null;
          },
          isExpanded: true,
        ),
      ),
    );

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
    formWidget.add(
      Container(
        margin: const EdgeInsets.only(top: 35),
        child: Row(
          children: const [
            Icon(Icons.saved_search),
            SizedBox(width: 8),
            Text(
              'Motivo de Entrega',
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
        margin: const EdgeInsets.only(top: 5),
        child: DropdownButtonFormField<String>(
          hint: const Text('Selecione o motivo'),
          items: motivoList,
          onChanged: (value) {
            setState(() {
              selectedMotivo = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Selecione uma opção para continuar';
            }
            return null;
          },
          isExpanded: true,
        ),
      ),
    );
    formWidget.add(
      Container(
        margin: const EdgeInsets.only(top: 35),
        child: Row(
          children: const [
            Icon(Icons.people_alt_sharp),
            SizedBox(width: 8),
            Text(
              'Responsável',
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
        margin: const EdgeInsets.only(top: 5),
        child: DropdownButtonFormField<String>(
          hint: const Text('Selecione o responsavel'),
          items: responsavelList,
          onChanged: (value) {
            setState(() {
              selectedResponsavel = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Selecione um responsável';
            }
            return null;
          },
          isExpanded: true,
        ),
      ),
    );
    formWidget.add(
      Container(
        margin: const EdgeInsets.only(top: 25),
        child: Row(
          children: const [
            Icon(Icons.chat_bubble),
            SizedBox(width: 8),
            Text(
              'Descrição',
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
          controller: descricao,
          keyboardType: TextInputType.text,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Digite aqui',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Informe uma descrição para o recebimento.';
            } else if (value.length >= 254) {
              return 'A descrição deve ter menos de 254 caracteres.';
            }
            return null;
          },
        ),
      ),
    );

    Future<void> onPressedSubmit() async {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState?.save();
        //imprime no console os dados.
        print("Modelo ONU: " + selectedModel.toString());
        print("Serial ONU: " + serial.text);
        print("Motivo: " + selectedMotivo.toString());
        print("Responsável: " + selectedResponsavel.toString());
        print("Descrição: " + descricao.text);

        var resposta = await CadastrarOnuRepository().store(CadastrarOnu(
          tipo_onu_estoque: selectedModel!,
          serial_estoque: serial.text,
          motivo_entrega: selectedMotivo!,
          desc_estoque: descricao.text,
          nome_responsavel: selectedResponsavel!,
        ));
        print(resposta);
        // faz verificação da resposta == false ou seja gravado.
        if (resposta == false) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Onu cadastrada com Sucesso!')));
          //aguarda e retorna para a página inicial.
          Timer(Duration(seconds: 4), () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Não foi possivel cadastrar a ONU.')));
        }
      }
    }

    formWidget.add(
      Container(
        margin: const EdgeInsets.only(top: 25),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            backgroundColor: const Color.fromARGB(255, 0, 81, 255),
          ),
          onPressed:
              onPressedSubmit, // Chama o método onPressedSubmit e envia os dados para o repository
          child: const Text(
            'Enviar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    return formWidget;
  }
}
