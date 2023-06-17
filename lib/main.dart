import 'package:app_estoque/src/cadastrar_onu/cadastrar_onu_page.dart';
import 'package:app_estoque/src/pesquisar_onu/entities/pesquisar_onu.dart';
import 'package:app_estoque/src/pesquisar_onu/pesquisar_onu_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_estoque/src/auth/auth_service.dart';
import 'package:app_estoque/src/auth/login_page.dart';
import 'package:app_estoque/src/auth/registration/registration_page.dart';
import 'package:app_estoque/src/home/home_page.dart';
import 'package:app_estoque/src/shared/themes/color_schemes.g.dart';

void main() {
  // ignore: prefer_const_constructors
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: _app(),
    );
  }

  Widget _app() {
    return MaterialApp(
      title: 'App Estoque',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      initialRoute: '/auth/login',
      routes: {
        '/auth/login': (context) => const LoginPage(),
        '/auth/registration': (context) => const RegistrationPage(),
        '/home': (context) => const HomePage(),
        '/serial_onu/cadastrar': (context) => const CadastrarOnuPage(),
        '/serial_onu/pesquisar': (context) => const PesquisarOnuPage(),
      },
    );
  }
}
