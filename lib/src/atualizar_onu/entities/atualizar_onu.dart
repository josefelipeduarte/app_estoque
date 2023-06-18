class AtualizarOnu {
  final String tipo_onu_estoque;
  final String motivo_entrega;
  final String desc_estoque;
  final String nome_responsavel;
  final String? user;
  final int? id;

  AtualizarOnu({
    this.id,
    required this.tipo_onu_estoque,
    required this.motivo_entrega,
    required this.desc_estoque,
    required this.nome_responsavel,
    this.user,
  });
  factory AtualizarOnu.fromJson(Map<String, dynamic> dados) {
    return AtualizarOnu(
      id: dados['id'] ?? '',
      tipo_onu_estoque: dados['tipo_onu_estoque'],
      motivo_entrega: dados['motivo_entrega'],
      desc_estoque: dados['desc_estoque'],
      nome_responsavel: dados['nome_responsavel'],
    );
  }
}
