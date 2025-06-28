import 'package:flutter/material.dart';
import '../model/filme.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Selecione seu assento',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: filme.assentos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8, // 8 assentos por fileira
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final ocupado = filme.assentos[index];
                  final selecionado = assentoSelecionado == index;

                  Color cor;
                  if (ocupado) {
                    cor = Colors.red;
                  } else if (selecionado) {
                    cor = Colors.green;
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
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Container(), // vazio, sem número
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: assentoSelecionado != null
                  ? () {
                      // Próxima etapa: tela de confirmação
                      // Por enquanto só mostra snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Assento ${assentoSelecionado! + 1} selecionado!',
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Confirmar assento',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
