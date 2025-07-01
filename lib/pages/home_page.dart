import 'package:flutter/material.dart';
import '../model/filme.dart';
import 'selecao_assentos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Filmes predefinidos
    final filmes = [
      Filme(
        id: '1',
        nome: 'Oppenheimer',
        posterUrl:
            'https://xl.movieposterdb.com/23_10/2023/15398776/xl_oppenheimer-movie-poster_0d167e2f.jpg',
        ano: 2023,
        assentos: List.filled(200, false),
        duracao: '2 h 58 min',
        resumo: "Escrito e dirigido por Christopher Nolan, Oppenheimer é um épico suspense filmado em IMAX® que leva o público ao paradoxo pulsante do homem enigmático que deve arriscar destruir o mundo para salvá-lo.",

      ),
      Filme(
        id: '2',
        nome: 'O Show de Truman',
        posterUrl:
            'https://xl.movieposterdb.com/09_02/1998/120382/xl_120382_f27e145a.jpg?v=2022-07-21%2014:09:05',
        ano: 1998,
        assentos: List.filled(150, false),
        duracao: '1 h 36 min',
        resumo: "Truman leva uma vida simples com sua esposa, sem saber que tudo ao seu redor é parte de um progama de TV. Aos poucos, acontecimentos despertam sua desconfiança.",
      ),
      Filme(
        id: '3',
        nome: 'Eu sou a Lenda',
        posterUrl:
            'https://xl.movieposterdb.com/08_04/2007/480249/xl_480249_f92d0462.jpg?v=2024-11-30%2005:13:42',
        ano: 2007,
        assentos: List.filled(180, false),
        duracao: '1 h 36 min',
        resumo: "Will Smith interpreta este solitário sobrevivente em Eu Sou a Lenda, um épico de ação que mistura doses generosas de tensão com uma incrível visão de uma desolada Manhattan.",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black, // Cor de fundo preta

      // Barra superior com o título do app
      appBar: AppBar(
        title: const Text('Absoluto Cinema'),
        backgroundColor: Colors.red[900], // Vermelho escuro
        centerTitle: true, // Centraliza o texto
      ),

      // Corpo da tela
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título "Filmes em destaque"
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '🍿 Filmes em destaque',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16), // Espaçamento

            // Lista horizontal de cards de filmes
            SizedBox(
              height: 280, // Altura total do card
              child: ListView.separated(
                scrollDirection: Axis.horizontal, // Rola para o lado
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filmes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16), // Espaço entre os cards

                // Monta cada item (filme)
                itemBuilder: (context, index) {
                  final filme = filmes[index];

                  return GestureDetector(
                    // Ao clicar no card, abre a tela de assentos passando o filme
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SelecaoAssentosPage(filme: filme),
                        ),
                      );
                    },

                    // Card visual do filme
                    child: Card(
                      color: Colors.grey[900], // Cor escura para combinar com fundo preto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SizedBox(
                        width: 150, // Largura fixa do card
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Imagem do poster do filme com cantos arredondados em cima
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.network(
                                filme.posterUrl,
                                height: 200,
                                width: 150,
                                fit: BoxFit.contain, // Ajusta a imagem no espaço
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: 200,
                                  width: 150,
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12), // Espaço entre imagem e texto

                            // Nome e ano do filme
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  // Nome do filme
                                  Text(
                                    filme.nome,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1, // Limita a 1 linha
                                    overflow: TextOverflow.ellipsis, // Coloca "..." se for muito grande
                                  ),

                                  const SizedBox(height: 4),

                                  // Ano do filme
                                  Text(
                                    '${filme.ano}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}
