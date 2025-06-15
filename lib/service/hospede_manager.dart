// hospede_manager.dart
import 'dart:convert';

import 'package:flutter_application_1/model/hospede_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HospedeManager {
  static const _listaHospedesKey = 'lista_hospedes';

  Future<List<Hospede>> getTodosHospedes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? hospedesJsonString = prefs.getString(_listaHospedesKey);
    if (hospedesJsonString != null) {
      final List<dynamic> hospedesListMap = json.decode(hospedesJsonString);
      return hospedesListMap.map((map) => Hospede.fromMap(map)).toList();
    }
    return [];
  }

  Future<void> _salvarLista(List<Hospede> hospedes) async {
    final List<Map<String, dynamic>> hospedesListMap =
        hospedes.map((h) => h.toMap()).toList();
    final String hospedesJsonString = json.encode(hospedesListMap);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_listaHospedesKey, hospedesJsonString);
  }

  Future<void> cadastrarHospede(Hospede novoHospede) async {
    final List<Hospede> hospedesAtuais = await getTodosHospedes();
    hospedesAtuais.add(novoHospede);
    await _salvarLista(hospedesAtuais);
  }

  Future<void> atualizarHospede(Hospede hospedeAtualizado) async {
    final List<Hospede> hospedesAtuais = await getTodosHospedes();
    final index =
        hospedesAtuais.indexWhere((h) => h.cpf == hospedeAtualizado.cpf);
    if (index != -1) {
      hospedesAtuais[index] = hospedeAtualizado;
      await _salvarLista(hospedesAtuais);
    }
  }

  Future<void> deletarHospede(String cpf) async {
    final List<Hospede> hospedesAtuais = await getTodosHospedes();
    hospedesAtuais.removeWhere((h) => h.cpf == cpf);
    await _salvarLista(hospedesAtuais);
  }
}
