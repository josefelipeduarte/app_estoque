import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_estoque/src/auth/auth_service.dart';
import 'package:app_estoque/src/auth/login_page.dart';
import 'package:app_estoque/src/auth/registration/registration_page.dart';
import 'package:app_estoque/src/complaint/complaint_page.dart';
import 'package:app_estoque/src/home/home_page.dart';
import 'package:app_estoque/src/panel/panel_page.dart';
import 'package:app_estoque/src/schools/school_form_page.dart';
import 'package:app_estoque/src/schools/schools_list_page.dart';
import 'package:app_estoque/src/shared/themes/color_schemes.g.dart';
import 'package:app_estoque/src/auth/auth_service.dart';

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
      title: 'Escolas Seguras',
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
        '/schools/list': (context) => const SchoolsListPage(),
        '/schools/form': (context) => const SchoolFormPage(),
        '/complaint': (context) => const ComplaintPage(),
        '/panel': (context) => PanelPage(),
      },
    );
  }
}
