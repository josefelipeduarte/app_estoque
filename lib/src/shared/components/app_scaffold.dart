import 'package:flutter/material.dart';
import 'package:app_estoque/src/shared/components/app_drawer.dart';

class AppScaffold extends StatelessWidget {
  final String? pageTitle;
  final Widget? child;

  const AppScaffold({super.key, this.child, this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(pageTitle ?? 'App Estoque'),
      ),
      body: child,
    );
  }
}
