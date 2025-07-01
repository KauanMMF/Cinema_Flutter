import 'package:flutter/material.dart';
import '../model/filme.dart';
import '../pages/carrinho.dart';
import '../model/ingresso.dart';

class SelecaoAssentosPage extends StatefulWidget {
  final Filme filme;

  const SelecaoAssentosPage({super.key, required this.filme});

  @override
  State<SelecaoAssentosPage> createState() => _SelecaoAssentosPageState();
}

class _SelecaoAssentosPageState extends State<SelecaoAssentosPage> {
  int? assentoSelecionado;

  @override
  Widget build(BuildContext context) {
    final filme = widget.filme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Assentos - ${filme.nome}'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 750),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Selecione seu assento',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 400,
                    child: GridView.builder(
                      itemCount: filme.assentos.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 15,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 55,
                      ),
                      itemBuilder: (context, index) {
                        final ocupado = filme.assentos[index];
                        final selecionado = assentoSelecionado == index;
                        final numeroAssento = index + 1;

                        Color cor;
                        if (ocupado) {
                          cor = Colors.red[700]!;
                        } else if (selecionado) {
                          cor = Colors.green[600]!;
                        } else {
                          cor = Colors.white;
                        }

                        return GestureDetector(
                          onTap: ocupado
                              ? null
                              : () {
                                  setState(() {
                                    assentoSelecionado = index;
                                  });
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              color: cor,
                              borderRadius: BorderRadius.circular(6),
                              border: selecionado
                                  ? Border.all(color: Colors.blueAccent, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.chair,
                                    color: ocupado ? Colors.white : Colors.black,
                                    size: 28,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$numeroAssento',
                                    style: TextStyle(
                                      color: ocupado ? Colors.white : Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                 ElevatedButton(
  onPressed: assentoSelecionado != null
      ? () {
          final ingresso = Ingresso(
            assento: (assentoSelecionado! + 1).toString(),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarrinhoPage(
                filme: filme,
                assento: ingresso,
              ),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Assento ${assentoSelecionado! + 1} selecionado!',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green[700],
              duration: const Duration(seconds: 2),
            ),
          );
        }
      : null,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Confirmar Assento',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 30),
            Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalhes da Sessão',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Filme: ${filme.nome}',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    'Filme: ${filme.ano}',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Duração: ${filme.duracao}',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Gênero: ${filme.resumo}',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Assento Selecionado: ${assentoSelecionado != null ? assentoSelecionado! + 1 : 'Nenhum'}',
                    style: TextStyle(
                      color: assentoSelecionado != null ? Colors.greenAccent : Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Preço: R\$ 25.00',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
