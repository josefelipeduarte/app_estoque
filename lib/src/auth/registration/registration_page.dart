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
      pageTitle: 'Cadastrar ONU Recebida',
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

//somente para mostrar ADM sim ou não
class YesNoFormField extends FormField<bool> {
  YesNoFormField({
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<bool> field) {
            final theme = Theme.of(field.context);
            return Column(
              children: [
                ListTile(
                  title: const Text('Sim'),
                  leading: Radio<bool>(
                    value: true,
                    groupValue: field.value,
                    onChanged: field.didChange,
                  ),
                ),
                ListTile(
                  title: const Text('Não'),
                  leading: Radio<bool>(
                    value: false,
                    groupValue: field.value,
                    onChanged: field.didChange,
                  ),
                ),
                if (field.hasError)
                  Text(
                    field.errorText!,
                    style: TextStyle(color: theme.errorColor),
                  ),
              ],
            );
          },
        );
}

class FormItems extends StatelessWidget {
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

  var selected;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            controller: userName,
            decoration: const InputDecoration(
                hintText: 'Usuário', icon: Icon(Icons.person_outline)),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: password,
            decoration: const InputDecoration(
                hintText: 'Senha', icon: Icon(Icons.password_outlined)),
            obscureText: true,
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: email,
            decoration: const InputDecoration(
                hintText: 'Email', icon: Icon(Icons.email_outlined)),
          ),
          const SizedBox(
            height: 8.0,
          ),
          YesNoFormField(
            onSaved: (value) {
              selected = value;
            },
            validator: (value) {
              if (value == null) {
                return 'Por favor, selecione uma opção.';
              }
              return null;
            },
          ),
          const SizedBox(height: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () async {
                  var registrationResponse =
                      await RegistrationRepository().store(
                    Registration(
                      email: email.text,
                      password: password.text,
                      name: userName.text,
                    ),
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
                                  style: const TextStyle(color: Colors.white),
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => PanelPage()));
                    });
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
    );
  }
}
