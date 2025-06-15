class Quarto {
  final String id;
  final String nome;
  final String numero;
  final String tipo;
  final String? observacoes;
  final bool ocupado;

  Quarto({
    required this.id,
    required this.nome,
    required this.numero,
    required this.tipo,
    this.observacoes,
    this.ocupado = false,
  });

  // cria um novo quarto com as alterações
  Quarto cloneAlterado({
    String? nome,
    String? numero,
    String? tipo,
    String? observacoes,
    bool? ocupado,
  }) {
    return Quarto(
      id: id,
      nome: nome ?? this.nome,
      numero: numero ?? this.numero,
      tipo: tipo ?? this.tipo,
      observacoes: observacoes ?? this.observacoes,
      ocupado: ocupado ?? this.ocupado,
    );
  }

  // converte o JSON de quarto para um objeto
  factory Quarto.fromJson(Map<String, dynamic> json) {
    return Quarto(
      id: json['id'],
      nome: json['nome'],
      numero: json['numero'],
      tipo: json['tipo'],
      observacoes: json['observacoes'],
      ocupado: json['ocupado'] ?? false,
    );
  }

  // vai fazer o inverso do método assim de objeto -> json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'numero': numero,
      'tipo': tipo,
      'observacoes': observacoes,
      'ocupado': ocupado,
    };
  }
}
