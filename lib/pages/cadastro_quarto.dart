import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/quarto.dart';
import 'package:flutter_application_1/service/quarto_manager.dart';
import 'package:flutter_application_1/components/barra_lateral.dart';
import 'package:flutter_application_1/pages/lista_quartos.dart';

class CadastroQuarto extends StatefulWidget {
  final String titulo;
  final Quarto? quartoParaEditar;

  const CadastroQuarto({super.key, required this.titulo, this.quartoParaEditar});

  @override
  State<CadastroQuarto> createState() => _CadastroQuartoState();
}

class _CadastroQuartoState extends State<CadastroQuarto> {
  final chaveDoForm = GlobalKey<FormState>();
  final nome = TextEditingController();
  final numero = TextEditingController();
  final observacoes = TextEditingController();
  String? tipoSelecionado;
  bool disponivel = true;

  final quartoManager = QuartoManager();

  bool get estaEditandoQuarto => widget.quartoParaEditar != null;

  final List<String> tiposQuartos = [
    'Solteiro',
    'Casal',
    'Suíte',
    'Deluxe',
  ];

  @override
  void initState() {
    super.initState();
    if (estaEditandoQuarto) {
      final quarto = widget.quartoParaEditar!;
      nome.text = quarto.nome;
      numero.text = quarto.numero;
      tipoSelecionado = quarto.tipo;
      observacoes.text = quarto.observacoes ?? '';
      disponivel = !quarto.ocupado;
    }
  }

  void salvarInformacoes() async {
    if (chaveDoForm.currentState!.validate()) {
      final novoQuarto = Quarto(
        //colocando a data atual como ID para o cadastro
        id: estaEditandoQuarto ? widget.quartoParaEditar!.id : DateTime.now().toIso8601String(),
        nome: nome.text,
        numero: numero.text,
        tipo: tipoSelecionado!,
        observacoes: observacoes.text,
        ocupado: !disponivel,
      );

      if (estaEditandoQuarto) {
        await quartoManager.atualizarQuarto(novoQuarto);
      } else {
        await quartoManager.cadastrarQuarto(novoQuarto);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(estaEditandoQuarto ? 'Quarto atualizado!' : 'Quarto cadastrado!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ListaQuartos()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      drawer: const BarraLateral(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: chaveDoForm,
          child: ListView(
            children: [
              TextFormField(
                controller: nome,
                decoration: const InputDecoration(
                  labelText: 'Nome do Quarto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: numero,
                decoration: const InputDecoration(
                  labelText: 'Número do Quarto',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Informe o número' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: tipoSelecionado,
                items: tiposQuartos.map((tipo) {
                  return DropdownMenuItem(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  labelText: 'Tipo de Quarto',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => tipoSelecionado = value),
                validator: (value) => value == null ? 'Selecione o tipo' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: observacoes,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                title: const Text('Quarto Disponível'),
                value: disponivel,
                onChanged: (value) => setState(() => disponivel = value!),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: salvarInformacoes,
                child: Text(estaEditandoQuarto ? 'Salvar Alterações' : 'Cadastrar'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListaQuartos(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.red,
                ),
                child: const Text('Voltar para Lista de Quartos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}