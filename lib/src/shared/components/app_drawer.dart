import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_estoque/src/auth/auth_service.dart';
import 'package:app_estoque/src/shared/helpers/string_helpers.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Row(
              children: [
                CircleAvatar(
                  child: Text(
                    authService.user?.name[0] ?? '-',
                  ),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  StringHelpers.truncateWithEllipsis(
                    15,
                    authService.user?.name ?? '-',
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Inicio'),
            onTap: () {
              Navigator.of(context)
                  .popUntil((route) => !Navigator.of(context).canPop());
              Navigator.popAndPushNamed(context, '/home');
            },
          ),
          //Desabilitado por enquanto, posterior para cadastrar os usuários que acessam o sistema
          // ListTile(
          //   title: const Text('Cadastrar Usuário'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/auth/registration');
          //   },
          // ),
          ListTile(
            title: const Text('Cadastrar ONU'),
            onTap: () {
              Navigator.pushNamed(context, '/serial_onu/cadastrar');
            },
          ),
          ListTile(
            title: const Text('Pesquisar ONU'),
            onTap: () {
              Navigator.pushNamed(context, '/serial_onu/pesquisar');
            },
          ),
          ListTile(
            title: const Text('Escolas'),
            onTap: () {
              Navigator.pushNamed(context, '/schools/list');
            },
          ),
          ListTile(
            title: const Text('Sair'),
            onTap: () {
              authService.logout().then((value) {
                Navigator.of(context)
                    .popUntil((route) => !Navigator.of(context).canPop());
                Navigator.of(context).popAndPushNamed('/auth/login');
              });
            },
          ),
        ],
      ),
    );
  }
}