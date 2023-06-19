import 'dart:async';
import 'package:app_estoque/src/atualizar_onu/atualizar_onu_repository.dart';
import 'package:app_estoque/src/atualizar_onu/entities/atualizar_onu.dart';
import 'package:app_estoque/src/pesquisar_onu/pesquisar_onu_page.dart';
import 'package:flutter/material.dart';

class EditUser extends StatefulWidget {
  String estoqueId;
  String serialEstoque;
  String tipoOnu;
  String motivoEntrega;
  String? descEstoque;
  String nomeResponsavel;

  EditUser(
      {required this.estoqueId,
      required this.serialEstoque,
      required this.tipoOnu,
      required this.motivoEntrega,
      required this.descEstoque,
      required this.nomeResponsavel});
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final TextEditingController _controllerSerial = new TextEditingController();
  final TextEditingController _controllerMotivo = new TextEditingController();
  final TextEditingController _controllerDesEstoque =
      new TextEditingController();
  final TextEditingController _controllerResp = new TextEditingController();

  String estoqueId = '';
  String responsavel = '';
  String motivoEntrega = '';
  String tipoOnu = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      estoqueId = widget.estoqueId;
      _controllerSerial.text = widget.serialEstoque;
      _controllerDesEstoque.text = widget.descEstoque!;
      _controllerResp.text = widget.nomeResponsavel;

      tipoOnu = widget.tipoOnu;
      responsavel = widget.nomeResponsavel;
      motivoEntrega = widget.motivoEntrega;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Gravação"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return ListView(
      padding: EdgeInsets.all(30),
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        DropdownButtonFormField<String>(
          value: tipoOnu,
          onChanged: (value) {
            setState(() {
              tipoOnu = value!;
            });
          },
          decoration: InputDecoration(
            labelText: 'Tipo de ONU',
            prefixIcon: Icon(Icons.all_inbox),
            border: OutlineInputBorder(),
          ),
          items: [
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
          ],
        ),
        SizedBox(
          height: 40,
        ),
        TextField(
          controller: _controllerSerial,
          enabled: false,
          keyboardType: TextInputType.text,
          maxLines: 1,
          decoration: InputDecoration(
            hintText: 'Serial Da ONU',
            prefixIcon: Icon(Icons.key),
            labelText: 'Serial Da ONU',
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        DropdownButtonFormField<String>(
          value: motivoEntrega,
          onChanged: (value) {
            setState(() {
              motivoEntrega = value!;
            });
          },
          decoration: InputDecoration(
            labelText: 'Motivo de Entrega',
            prefixIcon: Icon(Icons.saved_search),
            border: OutlineInputBorder(),
          ),
          items: [
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
          ],
        ),
        SizedBox(
          height: 40,
        ),
        DropdownButtonFormField<String>(
          value: responsavel,
          onChanged: (value) {
            setState(() {
              responsavel = value!;
            });
          },
          decoration: InputDecoration(
            labelText: 'Responsável',
            prefixIcon: Icon(Icons.people_alt_sharp),
            border: OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(
              value: 'Adriano',
              child: Text('Adriano'),
            ),
            DropdownMenuItem(
              value: 'Andreza',
              child: Text('Andreza'),
            ),
            // Adicione mais itens do dropdown conforme necessário
          ],
        ),
        SizedBox(
          height: 40,
        ),
        TextField(
          controller: _controllerDesEstoque,
          keyboardType: TextInputType.text,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Descrição',
            prefixIcon: Icon(Icons.chat_bubble),
            labelText: 'Descrição',
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        TextButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            backgroundColor: const Color.fromARGB(255, 0, 81, 255),
          ),
          onPressed: () {
            editUser();
          },
          child: Text(
            'Atualizar',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  editUser() async {
    var resp = responsavel;
    var motivo = motivoEntrega;
    var tipo = tipoOnu;
    var descEstoque = _controllerDesEstoque.text;
    var idEst = int.parse(estoqueId);

    var resposta = await AtualizarOnuRepository().update(AtualizarOnu(
      tipo_onu_estoque: tipo,
      motivo_entrega: motivo,
      desc_estoque: descEstoque,
      nome_responsavel: resp,
      id: idEst,
    ));
    // faz verificação da resposta.
    if (resposta == true) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Onu atualizada com sucesso.')));
      //Aguarda um tempo e volta com o usuário para página de cadastro.
      Timer(Duration(seconds: 4), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PesquisarOnuPage()));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possivel atualizar a ONU.')));
    }
  }
}
