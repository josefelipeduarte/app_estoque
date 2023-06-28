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
              Navigator.popAndPushNamed(context, '/serial_onu/painel');
            },
          ),
          if (authService.user!.isAdmin) // Mostrar apenas se for admin
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
          const ListTile(
            title: Divider(
              color: Colors.grey,
              height: 1,
            ),
          ),
          if (authService.user!.isAdmin) // Mostrar apenas se for admin
            ListTile(
              title: const Text('Cadastrar Usuários'),
              onTap: () {
                Navigator.pushNamed(context, '/auth/registration');
              },
            ),
          ListTile(
            title: const Text('Listar Usuários'),
            onTap: () {
              Navigator.pushNamed(context, '/auth/listarUsers');
            },
          ),
          const ListTile(
            title: Divider(
              color: Colors.grey,
              height: 1,
            ),
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
