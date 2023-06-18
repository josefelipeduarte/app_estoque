import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_estoque/src/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (authService.user == null) {
        authService.hasToken().then((value) {
          if (value == true) {
            authService.initUser().then((_) {
              if (authService.user != null) {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController userName = TextEditingController();
    TextEditingController password = TextEditingController();
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'App Estoque',
              style: TextStyle(color: Color.fromARGB(255, 0, 81, 255)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Image.network(
                  'https://media.tenor.com/1G7KLUiquh0AAAAi/typing-fast.gif',
                  width: 100, // Defina a largura desejada da imagem
                  height: 100, // Defina a altura desejada da imagem
                ),
                const SizedBox(height: 5),
                FormItems(
                  userName: userName,
                  password: password,
                  authService: authService,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormItems extends StatelessWidget {
  const FormItems({
    super.key,
    required this.userName,
    required this.password,
    required this.authService,
  });

  final TextEditingController userName;
  final TextEditingController password;
  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(50.0),
            child: const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "App Estoque Master \n Cadastre aqui os seriais de ONUS recebidas no suporte.",
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 81, 255), fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TextFormField(
            controller: userName,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  width: 0.5,
                  style: BorderStyle.none,
                ),
              ),
              hintText: 'Email',
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 0, 81, 255)),
            ),
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(
            height: 8.0,
          ),
          TextFormField(
            controller: password,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  width: 0.5,
                  style: BorderStyle.none,
                  color: Colors.white,
                ),
              ),
              hintText: 'Senha',
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 0, 81, 255)),
            ),
            style: const TextStyle(color: Colors.black),
            obscureText: true,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  authService.login(userName.text, password.text).then(
                    (value) {
                      if (value == true) {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Não foi possivel logar no sistema.')));
                      }
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 81, 255),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
            ],
          )
        ]);
  }
}
