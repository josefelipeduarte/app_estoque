import 'dart:async';

import 'package:app_estoque/src/panel/panel_page.dart';
import 'package:app_estoque/src/shared/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_estoque/src/auth/auth_service.dart';
import 'package:app_estoque/src/auth/registration/registration_repository.dart';

import 'entities/registration.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationState();
}

class _RegistrationState extends State<RegistrationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController userName = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController email = TextEditingController();
    final authService = Provider.of<AuthService>(context);

    return AppScaffold(
      pageTitle: 'Cadastrar Usuário',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: FormItems(
            userName: userName,
            password: password,
            email: email,
            authService: authService),
      ),
    );
  }
}

class FormItems extends StatefulWidget {
  final TextEditingController userName;
  final TextEditingController password;
  final TextEditingController email;

  final AuthService authService;

  const FormItems(
      {super.key,
      required this.userName,
      required this.password,
      required this.email,
      required this.authService});

  @override
  State<FormItems> createState() => _FormItemsState();
}

String _selectedValue = "";
String? valorSelecionado;
List<String> listOfValue = ['', 'Sim', 'Não'];

class _FormItemsState extends State<FormItems> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 12, 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: widget.userName,
              decoration: const InputDecoration(
                  hintText: 'Usuário', icon: Icon(Icons.person_add)),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              controller: widget.password,
              decoration: const InputDecoration(
                  hintText: 'Senha', icon: Icon(Icons.key)),
              obscureText: true,
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormField(
              controller: widget.email,
              decoration: const InputDecoration(
                  hintText: 'Email', icon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(
              height: 8.0,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Usuário é admin?',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InputDecorator(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.workspace_premium_outlined),
                    hintText: 'Usuário admin?',
                  ),
                  child: DropdownButtonFormField(
                    value: _selectedValue,
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        valorSelecionado = value!;
                        print(valorSelecionado);
                      });
                    },
                    onSaved: (value) {
                      setState(() {
                        valorSelecionado = value!;
                        print(valorSelecionado);
                      });
                    },
                    items: listOfValue.map((String val) {
                      return DropdownMenuItem(
                        key: ValueKey(val),
                        value: val,
                        child: Text(val),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: () async {
                    if (valorSelecionado != null && valorSelecionado != "") {
                      int resultado = valorSelecionado == "Sim" ? 1 : 0;

                      var registrationResponse =
                          await RegistrationRepository().store(
                        Registration(
                            email: widget.email.text,
                            password: widget.password.text,
                            name: widget.userName.text,
                            admin: resultado),
                      );

                      if (registrationResponse.error) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: Container(
                                padding: const EdgeInsets.all(12),
                                height: 90,
                                decoration: BoxDecoration(
                                    color: Colors.red[600],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(22))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Houve um erro',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text(
                                      registrationResponse.reason,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ))));
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: Container(
                                padding: const EdgeInsets.all(12),
                                height: 90,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 0, 81, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(22))),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Usuário criado com sucesso.',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    Text(
                                      "Basta acessar agora para utilizar o sistema. \n você será redirecionado em 4 segundos.",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ))));
                        Timer(Duration(seconds: 4), () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PanelPage()));
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              'Por favor selecione se o usuário é admin ou não.')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 0, 81, 255),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
