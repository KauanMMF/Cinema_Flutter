class Filme {
  final String id;
  final String nome;
  final String posterUrl;
  final int ano;
  final List<bool> assentos; // true = ocupado, false = disponível

  Filme({
    required this.id,
    required this.nome,
    required this.posterUrl,
    required this.ano,
    required this.assentos,
  });
}
