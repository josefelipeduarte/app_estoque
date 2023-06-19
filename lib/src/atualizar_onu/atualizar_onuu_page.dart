import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  final TextEditingController _controllerTipoOnu = new TextEditingController();
  final TextEditingController _controllerMotivo = new TextEditingController();
  final TextEditingController _controllerDesEstoque =
      new TextEditingController();
  final TextEditingController _controllerResp = new TextEditingController();

  String estoqueId = '';
  String responsavel = '';
  String motivoEntrega = '';
  String modeloOnu = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      estoqueId = widget.estoqueId;
      _controllerSerial.text = widget.serialEstoque;
      _controllerDesEstoque.text = widget.descEstoque!;
      _controllerResp.text = widget.nomeResponsavel;

      modeloOnu = widget.tipoOnu;
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
          value: modeloOnu,
          onChanged: (value) {
            setState(() {
              modeloOnu = value!;
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
    var responsavel = _controllerResp.text;
    var motivo = _controllerMotivo.text;

    print("resultado final");
    print(responsavel);
    print(motivo);
  }
}
