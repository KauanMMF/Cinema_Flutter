import 'dart:convert';

class User {
  final String name;
  final String cpf;
  final String email;
  final String password; // Apenas para simulação!

  User({
    required this.name,
    required this.cpf,
    required this.email,
    required this.password,
  });

  // Converte um objeto User para um Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cpf': cpf,
      'email': email,
      'password': password,
    };
  }

  // Cria um objeto User a partir de um Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      cpf: map['cpf'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  // Converte o objeto para uma String JSON
  String toJson() => json.encode(toMap());

  // Cria um objeto a partir de uma String JSON
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
