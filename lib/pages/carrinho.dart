import 'package:flutter/material.dart';
import '../model/filme.dart';
import '../model/ingresso.dart';

class CarrinhoPage extends StatefulWidget {
  final Filme filme;
  final Ingresso assento;
  const CarrinhoPage({super.key, required this.filme, required this.assento});

  @override
  State<CarrinhoPage> createState() => CarrinhoPageState();
}

class CarrinhoPageState extends State<CarrinhoPage> {
  int? assentoSelecionado;

  @override
  Widget build(BuildContext context) {
    final filme = widget.filme;
    final ingresso = widget.assento;


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Assentos - ${filme.nome}'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 900,
          height: 300,
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
                'Detalhes da reserva',
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
              const SizedBox(height: 10),
              Text(
                'Duração: ${filme.duracao}',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Assento Selecionado: ${ingresso.assento}',
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: ingresso.assento != null
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Reserva confirmada!',

                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green[700],
                            duration: const Duration(seconds: 2),
                          ),
                        );

                        // Aqui poderia navegar para próxima tela
                        // Navigator.push(...);
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
      ),
    );
  }
}
