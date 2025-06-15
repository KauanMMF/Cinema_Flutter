import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/hospede_form.dart';
import 'package:flutter_application_1/pages/cadatro.dart';
import 'package:flutter_application_1/service/account_manager.dart';
import 'package:flutter_application_1/service/sesseion.dart';

class LoginUsuario extends StatefulWidget {
  const LoginUsuario({super.key, required this.title});
  final String title;
  @override
  State<LoginUsuario> createState() => _LoginUsuarioState();
}

class _LoginUsuarioState extends State<LoginUsuario> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  final _accountManager = AccountManager();
  final _sessionManager = SessionManager();

  Future<void> _login() async {
    // 1. Valida o formulário
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text;
      String password = _passwordController.text;

      // 2. Busca o usuário no "localStorage" usando o AccountManager
      final storedUser = await _accountManager.getUser(email);

      // 3. Verifica se o usuário existe e se a senha digitada confere com a salva
      bool loginSuccess = storedUser != null && storedUser.password == password;

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        if (loginSuccess) {
          // 4. Se o login for bem-sucedido, CRIA A SESSÃO
          await _sessionManager.createSession(storedUser!.name);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login realizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const CadastroHospede(title: 'Cadastro de Hóspede'),
            ),
          );
        } else {
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(
                  Icons.room_service,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Bem-vindo(a)!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32.0),

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

                // Campo Senha
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Sua senha',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
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
                  obscureText: _obscurePassword, // Oculta o texto da senha
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

                // Esqueceu a senha? (Opcional)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Implementar lógica de "Esqueceu a senha"
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Funcionalidade "Esqueceu a senha" a ser implementada.',
                          ),
                        ),
                      );
                    },
                    child: const Text('Esqueceu a senha?'),
                  ),
                ),
                const SizedBox(height: 24.0),

                // Botão de Login
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      ) // Mostra o indicador de carregamento
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                        ),
                        onPressed: _login, // Chama o método _login
                        child: const Text(
                          'ENTRAR',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                const SizedBox(height: 16.0),

                // Opção de Criar Conta (Opcional)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem uma conta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CadastroUsuario(),
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
