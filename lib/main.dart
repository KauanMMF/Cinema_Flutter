import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/CpfInputFormatter.dart';
import 'package:flutter_application_1/model/hsoepde_model.dart';
import 'package:flutter_application_1/pages/hospedes_list_screen.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/service/hospede_manager.dart';
import 'package:flutter_application_1/service/sesseion.dart';
import 'package:intl/intl.dart'; // <-- NÃO ESQUEÇA DE IMPORTAR

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário de Hotel',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(title: 'Cadastro de Hóspede'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  final Hospede? hospedeParaEditar;

  const MyHomePage({
    super.key,
    required this.title,
    this.hospedeParaEditar, // Adicionado ao construtor
  });
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeClienteController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _numeroQuartoController = TextEditingController();
  final TextEditingController _dataEntradaController = TextEditingController();
  final TextEditingController _dataSaidaController = TextEditingController();

  final _sessionManager = SessionManager();
  final _hospedeManager = HospedeManager();
  bool get _isEditing => widget.hospedeParaEditar != null;

  String? _username;

  DateTime? _dataEntrada;
  DateTime? _dataSaida;

  @override
  void initState() {
    super.initState();
    _loadUsername();

    if (_isEditing) {
      final hospede = widget.hospedeParaEditar!;
      _nomeClienteController.text = hospede.nome;
      _cpfController.text = hospede.cpf;
      _numeroQuartoController.text = hospede.numeroQuarto;
      _tipoQuartoSelecionado = hospede.tipoQuarto;
      _dataEntrada = hospede.dataEntrada;
      _dataEntradaController.text =
          DateFormat('dd/MM/yyyy').format(hospede.dataEntrada);
      _dataSaida = hospede.dataSaida;
      _dataSaidaController.text =
          DateFormat('dd/MM/yyyy').format(hospede.dataSaida);
    }
  }

  Future<void> _loadUsername() async {
    final session = await _sessionManager.getSession();

    setState(() {
      _username = session['username'];
    });
  }

  String? _tipoQuartoSelecionado;
  final List<String> _opcoesTipoQuarto = [
    'Solteiro',
    'Casal',
    'Suíte',
    'Deluxe',
  ];

  Future<void> _selectDate(BuildContext context,
      {required bool isEntrada}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isEntrada) {
          _dataEntrada = picked;
          _dataEntradaController.text = DateFormat('dd/MM/yyyy').format(picked);
        } else {
          _dataSaida = picked;
          _dataSaidaController.text = DateFormat('dd/MM/yyyy').format(picked);
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_isEditing) {
        final hospedeAtualizado = widget.hospedeParaEditar!.copyWith(
          nome: _nomeClienteController.text,
          numeroQuarto: _numeroQuartoController.text,
          tipoQuarto: _tipoQuartoSelecionado!,
          dataEntrada: _dataEntrada!,
          dataSaida: _dataSaida!,
        );
        await _hospedeManager.atualizarHospede(hospedeAtualizado);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hóspede atualizado com sucesso!')),
        );
        Navigator.of(context).pop();
      } else {
        final novoHospede = Hospede(
          nome: _nomeClienteController.text,
          cpf: _cpfController.text,
          numeroQuarto: _numeroQuartoController.text,
          tipoQuarto: _tipoQuartoSelecionado!,
          dataEntrada: _dataEntrada!,
          dataSaida: _dataSaida!,
        );
        await _hospedeManager.cadastrarHospede(novoHospede);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hóspede cadastrado com sucesso!')),
        );
        _clearForm();
      }
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nomeClienteController.clear();
    _cpfController.clear();
    _numeroQuartoController.clear();
    _dataEntradaController.clear();
    _dataSaidaController.clear();
    setState(() {
      _tipoQuartoSelecionado = null;
      _dataEntrada = null;
      _dataSaida = null;
    });
  }

  @override
  void dispose() {
    _nomeClienteController.dispose();
    _cpfController.dispose();
    _numeroQuartoController.dispose();
    _dataEntradaController.dispose();
    _dataSaidaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_isEditing ? 'Editar Hóspede' : widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'Olá, ${_username ?? 'carregando...'}!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nomeClienteController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Cliente',
                  hintText: 'Digite o nome do cliente',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome do cliente';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cpfController,
                readOnly: _isEditing,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  hintText: 'Digite o CPF',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CPF';
                  }

                  if (value.length != 14) {
                    return 'CPF deve ter 11 dígitos';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _numeroQuartoController,
                decoration: const InputDecoration(
                  labelText: 'Número do Quarto',
                  hintText: 'Digite o número do quarto',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o número do quarto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tipo do Quarto',
                  border: OutlineInputBorder(),
                ),
                value: _tipoQuartoSelecionado,
                hint: const Text('Selecione o tipo do quarto'),
                isExpanded: true,
                items: _opcoesTipoQuarto.map((String valor) {
                  return DropdownMenuItem<String>(
                    value: valor,
                    child: Text(valor),
                  );
                }).toList(),
                onChanged: (String? novoValor) {
                  setState(() {
                    _tipoQuartoSelecionado = novoValor;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione o tipo do quarto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _dataEntradaController,
                decoration: const InputDecoration(
                  labelText: 'Data de Entrada',
                  hintText: 'Selecione a data de entrada',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true, // Impede o usuário de digitar
                onTap: () => _selectDate(context, isEntrada: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione a data de entrada';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Campo Data de Saída
              TextFormField(
                controller: _dataSaidaController,
                decoration: const InputDecoration(
                  labelText: 'Data de Saída',
                  hintText: 'Selecione a data de saída',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true, // Impede o usuário de digitar
                onTap: () => _selectDate(context, isEntrada: false),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione a data de saída';
                  }
                  // Validação extra: Data de saída não pode ser antes da de entrada
                  if (_dataEntrada != null &&
                      _dataSaida != null &&
                      _dataSaida!.isBefore(_dataEntrada!)) {
                    return 'Data de saída deve ser após a entrada';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: _submitForm,
                      child:
                          Text(_isEditing ? 'Salvar Alterações' : 'Cadastrar'),
                    ),
                    const SizedBox(height: 5.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HospedesListScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        backgroundColor: Colors.grey[200],
                        foregroundColor: const Color.fromARGB(255, 241, 3, 3),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                      child: const Text('Listar Hóspedes'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
