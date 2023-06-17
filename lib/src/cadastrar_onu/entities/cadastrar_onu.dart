class CadastrarOnu {
  final int? id;
  final String tipo_onu_estoque;
  final String serial_estoque;
  final String motivo_entrega;
  final String desc_estoque;
  final String nome_responsavel;
  final String? user;

  CadastrarOnu({
    this.id,
    required this.tipo_onu_estoque,
    required this.serial_estoque,
    required this.motivo_entrega,
    required this.desc_estoque,
    required this.nome_responsavel,
    this.user,
  });
}
