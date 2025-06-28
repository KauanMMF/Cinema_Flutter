import 'package:flutter/material.dart';
import 'pages/login.dart'; // Importe a tela de login

void main() {
  runApp(const AbsolutoCinemaApp());
}

class AbsolutoCinemaApp extends StatelessWidget {
  const AbsolutoCinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absoluto Cinema',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.red[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red[900],
        ),
        cardColor: Colors.grey[900],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      home: const LoginUsuario(title: 'Login'), // Altere aqui
    );
  }
}
