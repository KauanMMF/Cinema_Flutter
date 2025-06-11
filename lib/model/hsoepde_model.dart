// hospede_model.dart
import 'dart:convert';

enum HospedeStatus { andamento, concluido, cancelado }

class Hospede {
  final String nome;
  final String cpf;
  final String numeroQuarto;
  final String tipoQuarto;
  final DateTime dataEntrada;
  final DateTime dataSaida;
  final HospedeStatus status;

  Hospede({
    required this.nome,
    required this.cpf,
    required this.numeroQuarto,
    required this.tipoQuarto,
    required this.dataEntrada,
    required this.dataSaida,
    this.status = HospedeStatus.andamento,
  });

  Hospede copyWith({
    String? nome,
    String? cpf,
    String? numeroQuarto,
    String? tipoQuarto,
    DateTime? dataEntrada,
    DateTime? dataSaida,
    HospedeStatus? status,
  }) {
    return Hospede(
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      numeroQuarto: numeroQuarto ?? this.numeroQuarto,
      tipoQuarto: tipoQuarto ?? this.tipoQuarto,
      dataEntrada: dataEntrada ?? this.dataEntrada,
      dataSaida: dataSaida ?? this.dataSaida,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'numeroQuarto': numeroQuarto,
      'tipoQuarto': tipoQuarto,
      'dataEntrada': dataEntrada.toIso8601String(),
      'dataSaida': dataSaida.toIso8601String(),
      'status': status.toString(),
    };
  }

  factory Hospede.fromMap(Map<String, dynamic> map) {
    return Hospede(
      nome: map['nome'] ?? '',
      cpf: map['cpf'] ?? '',
      numeroQuarto: map['numeroQuarto'] ?? '',
      tipoQuarto: map['tipoQuarto'] ?? '',
      dataEntrada: DateTime.parse(map['dataEntrada']),
      dataSaida: DateTime.parse(map['dataSaida']),
      // Converte a string de volta para o enum
      status: HospedeStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => HospedeStatus.andamento,
      ),
    );
  }

  String toJson() => json.encode(toMap());
  factory Hospede.fromJson(String source) =>
      Hospede.fromMap(json.decode(source));
}
