class Filme {
  final String id;
  final String nome;
  final String posterUrl;
  final int ano;
  final List<bool> assentos; 
  final String duracao; // true = ocupado, false = disponível
  final String resumo;

  Filme({
    required this.id,
    required this.nome,
    required this.posterUrl,
    required this.ano,
    required this.assentos,
    required this.duracao,
    required this.resumo,
  });
}
