import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/guest_card.dart';
import 'package:flutter_application_1/pages/hospede_form.dart'; // Idealmente, importe a classe MyHomePage diretamente
import 'package:flutter_application_1/model/hsoepde_model.dart';
import 'package:flutter_application_1/service/hospede_manager.dart';
import 'package:flutter_application_1/components/barra_lateral.dart';

class ListaHospedes extends StatefulWidget {
  const ListaHospedes({super.key});

  @override
  State<ListaHospedes> createState() => _ListaHospedesState();
}

class _ListaHospedesState extends State<ListaHospedes> {
  final HospedeManager _hospedeManager = HospedeManager();
  late Future<List<Hospede>> _hospedesFuture;

  @override
  void initState() {
    super.initState();
    _hospedesFuture = _hospedeManager.getTodosHospedes();
  }

  void _refreshHospedesList() {
    setState(() {
      _hospedesFuture = _hospedeManager.getTodosHospedes();
    });
  }

  void _navigateToEditScreen(Hospede hospede) async {
    // Espera a tela de edição fechar para então atualizar a lista
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CadastroHospede(
          title: 'Editar Hóspede',
          hospedeParaEditar: hospede,
        ),
      ),
    );
    _refreshHospedesList();
  }

  void _deleteHospede(String cpf) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content:
              const Text('Você tem certeza que deseja excluir este hóspede?'),
          actions: <Widget>[
            TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(false)),
            TextButton(
                child:
                    const Text('Excluir', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.of(context).pop(true)),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _hospedeManager.deletarHospede(cpf);
      _refreshHospedesList();
    }
  }

  void _changeHospedeStatus(Hospede hospede, HospedeStatus newStatus) async {
    final hospedeAtualizado = hospede.copyWith(status: newStatus);
    await _hospedeManager.atualizarHospede(hospedeAtualizado);
    _refreshHospedesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóspedes Cadastrados'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      drawer: const BarraLateral(),
      body: FutureBuilder<List<Hospede>>(
        future: _hospedesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar os dados: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhum hóspede cadastrado ainda.'));
          }

          final hospedes = snapshot.data!;
          return ListView.builder(
            itemCount: hospedes.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) {
              final hospede = hospedes[index];
              return GuestCard(
                hospede: hospede,
                onEdit: () => _navigateToEditScreen(hospede),
                onDelete: () => _deleteHospede(hospede.cpf),
                onStatusChange: (newStatus) =>
                    _changeHospedeStatus(hospede, newStatus),
              );
            },
          );
        },
      ),
    );
  }
}
