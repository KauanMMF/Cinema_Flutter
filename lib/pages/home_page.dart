import 'package:flutter/material.dart';
import '../model/filme.dart';
import 'selecao_assentos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final filmes = [
      Filme(
        id: '1',
        nome: 'Oppenheimer',
        posterUrl:
            'https://xl.movieposterdb.com/23_10/2023/15398776/xl_oppenheimer-movie-poster_0d167e2f.jpg',
        ano: 2023,
        assentos: List.filled(40, false),
      ),
      Filme(
        id: '2',
        nome: 'O Show de Truman',
        posterUrl:
            'https://xl.movieposterdb.com/09_02/1998/120382/xl_120382_f27e145a.jpg?v=2022-07-21%2014:09:05',
        ano: 1998,
        assentos: List.filled(40, false),
      ),
      Filme(
        id: '3',
        nome: 'Eu sou a Lenda',
        posterUrl:
            'https://xl.movieposterdb.com/08_04/2007/480249/xl_480249_f92d0462.jpg?v=2024-11-30%2005:13:42',
        ano: 2007,
        assentos: List.filled(40, false),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Absoluto Cinema'),
        backgroundColor: Colors.red[900],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 16),
            SizedBox(
              height: 280, // altura do card (imagem + texto)
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filmes.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final filme = filmes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SelecaoAssentosPage(filme: filme),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SizedBox(
                        width: 150,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16)),
                              child: Image.network(
                                filme.posterUrl,
                                height: 200,
                                width: 150,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  height: 200,
                                  width: 150,
                                  color: Colors.grey,
                                  child: const Icon(Icons.broken_image,
                                      color: Colors.white, size: 48),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  Text(
                                    filme.nome,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1, // Limita o nome a 1 linha
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
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
