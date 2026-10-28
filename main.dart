import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Multiplicação',
      home: MultiplicacaoPage(),
    );
  }
}

class MultiplicacaoPage extends StatefulWidget {
  const MultiplicacaoPage({super.key});

  @override
  State<MultiplicacaoPage> createState() => _MultiplicacaoPageState();
}

class _MultiplicacaoPageState extends State<MultiplicacaoPage> {
  final TextEditingController _respostaController = TextEditingController();
  int _fator = 1;
  int? _fatorAnterior;
  int? _multiplicadorAnterior;
  int _multiplicador = 1;

  void _proximaTabuada() {
    setState(() {
      _respostaController.clear();
      _fator = _fator == 10 ? 1 : _fator + 1;
      _multiplicador = 1;
    });
  }

  void _avancarOperacao() {
    if (_multiplicador == 10) {
      _proximaTabuada();
      return;
    }

    setState(() {
      _respostaController.clear();
      _multiplicador++;
    });
  }

  void _voltarParaTabuadaErrada() {
    final fatorErrado = _fatorAnterior;
    final multiplicadorErrado = _multiplicadorAnterior;
    if (fatorErrado == null || multiplicadorErrado == null) return;

    setState(() {
      _fator = fatorErrado;
      _multiplicador = multiplicadorErrado;
      _fatorAnterior = null;
      _multiplicadorAnterior = null;
      _respostaController.clear();
    });
  }

  void _verificarResposta() {
    final resposta = int.tryParse(_respostaController.text);
    final acertou = resposta == _fator * _multiplicador;

    if (acertou) {
      _avancarOperacao();
      return;
    }

    _fatorAnterior = _fator;
    _multiplicadorAnterior = _multiplicador;
    _proximaTabuada();

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Errou, clique aqui para continuar.'),
          action: SnackBarAction(
            label: 'Continuar',
            onPressed: _voltarParaTabuadaErrada,
          ),
        ),
      );
  }

  @override
  void dispose() {
    _respostaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multiplicação')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Quanto é $_fator × $_multiplicador?'),
            TextField(
              controller: _respostaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sua resposta'),
              onSubmitted: (_) => _verificarResposta(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _verificarResposta,
              child: const Text('Verificar'),
            ),
          ],
        ),
      ),
    );
  }
}
