import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/model/quarto.dart';

class QuartoManager {
  static const String chaveDoArmazenamento = 'quartos';

  Future<List<Quarto>> pegaTodosQuartos() async {
    final preferencias = await SharedPreferences.getInstance();
    final jsonString = preferencias.getString(chaveDoArmazenamento);

    if (jsonString == null) return [];

    final List<dynamic> traduz = jsonDecode(jsonString);
    return traduz.map((item) => Quarto.fromJson(item)).toList();
  }

  Future<void> cadastrarQuarto(Quarto quarto) async {
    final quartos = await pegaTodosQuartos();
    quartos.add(quarto);
    await _salvarLista(quartos);
  }

  Future<void> atualizarQuarto(Quarto quartoAtualizado) async {
    final quartos = await pegaTodosQuartos();
    final indice = quartos.indexWhere((q) => q.id == quartoAtualizado.id);

    // Se o quarto não for encontrado, não vai fazer nada, não encontrados retorna -1
    if (indice != -1) {
      quartos[indice] = quartoAtualizado;
      await _salvarLista(quartos);
    }
  }

  Future<void> deletarQuarto(String id) async {
    final quartos = await pegaTodosQuartos();
    quartos.removeWhere((q) => q.id == id);
    await _salvarLista(quartos);
  }

  Future<void> _salvarLista(List<Quarto> quartos) async {
    final preferencias = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(quartos.map((q) => q.toJson()).toList());
    await preferencias.setString(chaveDoArmazenamento, jsonString);
  }
}
