import 'package:app_estoque/src/auth/auth_service.dart';
import 'package:app_estoque/src/auth/pesquisa_user/entities/pesquisa.dart';
import 'package:app_estoque/src/auth/pesquisa_user/pesquisaUser_repository.dart';
import 'package:app_estoque/src/pesquisar_onu/pesquisar_onu_page.dart';
import 'package:app_estoque/src/shared/components/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ListarUsuarios extends StatefulWidget {
  const ListarUsuarios({Key? key}) : super(key: key);

  @override
  _ListarUsuariosState createState() => _ListarUsuariosState();
}

class _ListarUsuariosState extends State<ListarUsuarios> {
  @override
  void initState() {
    super.initState();
    getUsuarios();
  }

  var usuarios;
  Future<void> getUsuarios() async {
    try {
      usuarios = await PesquisarUserRepository().index();
      print(usuarios);
    } catch (error) {
      print("deu errado");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return AppScaffold(
      pageTitle: 'Usuários',
      child: Center(
        child: FutureBuilder(
          future: Future.delayed(Duration(seconds: 5)), // Aguarda 5 segundos
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Exibe o indicador de carregamento centralizado
              return CircularProgressIndicator();
            } else {
              // Atraso concluído, exibe o child desejado
              return listaUsers(usuarios: usuarios!);
            }
          },
        ),
      ),
    );
  }
}

class listaUsers extends StatelessWidget {
  final List<Map<String, dynamic>> usuarios;

  listaUsers({required this.usuarios});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        final item = usuarios[index];
        var status;

        deleteUser(item) async {
          String id = item['id'].toString();
          int parsedId = int.parse(id);

          await PesquisarUserRepository().deleteUser(parsedId);
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/auth/listarUsers');
        }

        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${item['id']}'),
              Text('Nome: ${item['name']}'),
              Text('email: ${item['email']}'),
              Text('email: ${item['is_admin'] == 1 ? "Admin" : "Usuário"}'),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (authService.user!.isAdmin) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirmação'),
                          content: const Text(
                              'Tem certeza que deseja excluir o item?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Fechar o diálogo
                              },
                            ),
                            TextButton.icon(
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red), // Cor do ícone e texto
                              ),
                              onPressed: () async {
                                deleteUser(item);

                                Navigator.of(context).pop(); // Fechar o diálogo
                              },
                              icon: Icon(Icons.delete), // Ícone de lixeira
                              label: const Text('Deletar',
                                  style: TextStyle(
                                      color: Colors
                                          .red)), // Texto "Deletar" com cor vermelha
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Sem permissão para deletar')));
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text('Deletar'),
              ),
            ],
          ),
        );
      },
    );
  }
}
