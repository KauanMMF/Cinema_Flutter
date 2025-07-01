import 'package:flutter/material.dart';
import '../pages/cadastro.dart';
import '../pages/home_page.dart'; 
import '../service/account_manager.dart';
import '../service/session.dart';

// Tela de Login principal, é um StatefulWidget pois precisa atualizar o estado (ex: mostrar loading)
class LoginUsuario extends StatefulWidget {
  const LoginUsuario({super.key, required this.title});
  final String title;

  @override
  State<LoginUsuario> createState() => _LoginUsuarioState();
}

// Estado da tela de Login
class _LoginUsuarioState extends State<LoginUsuario> {
  // Chave para validar o formulário
  final _formKey = GlobalKey<FormState>();
  // Controladores para pegar o texto digitado nos campos
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variáveis de controle de estado
  bool _isLoading = false; // Para mostrar o loading enquanto faz login
  bool _obscurePassword = true; // Para esconder/mostrar a senha

  // Gerenciadores de conta e sessão
  final _accountManager = AccountManager();
  final _sessionManager = SessionManager();

  // Função chamada ao clicar em "Entrar"
  Future<void> _login() async {
    // Valida o formulário
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Mostra o loading
      });

      String email = _emailController.text;
      String password = _passwordController.text;

      // Busca o usuário salvo pelo email
      final storedUser = await _accountManager.getUser(email);

      // Verifica se o usuário existe e a senha está correta
      bool loginSuccess = storedUser != null && storedUser.password == password;

      setState(() {
        _isLoading = false; // Esconde o loading
      });

      if (mounted) {
        if (loginSuccess) {
          // Cria a sessão do usuário
          await _sessionManager.createSession(storedUser.name);

          // Mostra mensagem de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login realizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          // Navega para a HomePage e remove a tela de login da pilha
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          // Mostra mensagem de erro
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email ou senha inválidos.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Libera os controladores quando a tela for destruída
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // TELA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior da tela
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      // Corp
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          // Formulário de login
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Ícone de cinema e de boas vindas
                Icon(
                  Icons.movie,
                  size: 80,
                  color: Colors.red[900], 
                ),
                const SizedBox(height: 24.0),

                Text(
                  'Bem-vindo(a)!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32.0),

                // Campo de email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'seuemail@exemplo.com',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Por favor, insira um email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Campo de senha
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Sua senha',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    // Botão para mostrar/ocultar senha
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),

                //onde ficava o esqueceu a senha

                // Botão de login ou loading
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          backgroundColor: Colors.red[900], 
                          foregroundColor: Colors.white, 
                        ),
                        onPressed: _login,
                        child: const Text(
                          'ENTRAR',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                const SizedBox(height: 16.0),

                // Link para tela de cadastro NAO TEM UMA CONTA?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem uma conta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CadastroUsuario(),
                          ),
                        );
                      },
                      child: const Text('Crie uma aqui'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}