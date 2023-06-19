import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditUser extends StatefulWidget {
  String estoqueId;
  String serialEstoque;
  String tipoOnu;
  String motivoEntrega;
  String descEstoque;
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
  final TextEditingController _controllerFullName = new TextEditingController();
  final TextEditingController _controllerEmail = new TextEditingController();
  String estoqueId = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      estoqueId = widget.estoqueId;
      _controllerFullName.text = widget.serialEstoque;
      _controllerEmail.text = widget.tipoOnu;

      print(widget.estoqueId);
      print(widget.serialEstoque);
      print(widget.tipoOnu);
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
        TextField(
          controller: _controllerFullName,
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            hintText: "FullName",
          ),
        ),
        SizedBox(
          height: 30,
        ),
        TextField(
          controller: _controllerEmail,
          cursorColor: Colors.blue,
          decoration: InputDecoration(
            hintText: "Email",
          ),
        ),
        SizedBox(
          height: 40,
        ),
        TextField(
          controller: _controllerEmail,
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
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(16.0),
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            editUser();
          },
          child: const Text('Gradient'),
        ),
      ],
    );
  }

  editUser() async {
    var fullName = _controllerFullName.text;
    var email = _controllerEmail.text;

    print("resultado final");
    print(fullName);
    print(email);
  }
}
