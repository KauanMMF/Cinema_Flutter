import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/barra_lateral.dart';
import 'package:flutter_application_1/model/quarto.dart';
import 'package:flutter_application_1/service/quarto_manager.dart';
import 'cadastro_quarto.dart';

class ListaQuartos extends StatefulWidget {
  const ListaQuartos({super.key});

  @override
  State<ListaQuartos> createState() => _ListaQuartosState();
}

class _ListaQuartosState extends State<ListaQuartos> {
  final QuartoManager quartoManager = QuartoManager();
  late Future<List<Quarto>> reqAssincronaDosQuartos;

  @override
  void initState() {
    super.initState();
    atualizaQuartos();
  }

  void atualizaQuartos() {
    setState(() {
      reqAssincronaDosQuartos = quartoManager.pegaTodosQuartos();
    });
  }

  void navegaParaCadastroQuarto([Quarto? quartoParaEditar]) async {
    // se tiver quarto para editar, muda a tela de cadastro para edição
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastroQuarto(
          titulo:
              quartoParaEditar == null ? 'Cadastrar Quarto' : 'Editar Quarto',
          quartoParaEditar: quartoParaEditar, // <-- Passa o quarto para edição
        ),
      ),
    );
    atualizaQuartos();
  }

  void deletaQuarto(String id) async {
    bool? confirmarExclusao = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir Quarto'),
        content: const Text('Tem certeza que deseja excluir este quarto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmarExclusao == true) {
      await quartoManager.deletarQuarto(id);
      atualizaQuartos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Quartos'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      drawer: const BarraLateral(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navegaParaCadastroQuarto(),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Quarto>>(
        future: reqAssincronaDosQuartos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final quartos = snapshot.data ?? [];

          if (quartos.isEmpty) {
            return const Center(child: Text('Nenhum quarto cadastrado ainda.'));
          }

          return ListView.builder(
            itemCount: quartos.length,
            itemBuilder: (context, index) {
              final quarto = quartos[index];
              return ListTile(
                leading: const Icon(Icons.bed),
                title: Text('${quarto.nome} - Nº ${quarto.numero}'),
                subtitle: Text('Tipo: ${quarto.tipo}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => navegaParaCadastroQuarto(quarto),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => deletaQuarto(quarto.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
