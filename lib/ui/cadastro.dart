import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/pessoa.dart';

class Cadastro extends StatefulWidget {
  final Pessoa? pessoa;

  const Cadastro({super.key, this.pessoa});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nome;
  late final TextEditingController cep;
  late final TextEditingController rua;
  late final TextEditingController bairro;
  late final TextEditingController cidade;
  late final TextEditingController estado;
  late final TextEditingController numero;
  late final TextEditingController complemento;

  Timer? _debounce;
  bool buscandoCep = false;
  String? erroCep;

  bool get editando => widget.pessoa != null;

  @override
  void initState() {
    super.initState();
    final p = widget.pessoa;
    nome = TextEditingController(text: p?.nome ?? '');
    cep = TextEditingController(text: p?.cep ?? '');
    rua = TextEditingController(text: p?.rua ?? '');
    bairro = TextEditingController(text: p?.bairro ?? '');
    cidade = TextEditingController(text: p?.cidade ?? '');
    estado = TextEditingController(text: p?.estado ?? '');
    numero = TextEditingController(text: p?.numero ?? '');
    complemento = TextEditingController(text: p?.complemento ?? '');
    cep.addListener(_cepAlterado);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    cep.removeListener(_cepAlterado);
    for (final c in [nome, cep, rua, bairro, cidade, estado, numero, complemento]) {
      c.dispose();
    }
    super.dispose();
  }

  void _cepAlterado() {
    final valor = cep.text.replaceAll(RegExp(r'\D'), '');
    _debounce?.cancel();
    if (valor.length != 8) return;
    _debounce = Timer(const Duration(milliseconds: 350), () => consultarCep(valor));
  }

  Future<void> consultarCep(String valor) async {
    setState(() {
      buscandoCep = true;
      erroCep = null;
    });

    try {
      final resposta = await http.get(Uri.parse('https://viacep.com.br/ws/$valor/json/'));
      if (resposta.statusCode != 200) throw Exception('Falha na consulta');
      final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
      if (dados['erro'] == true) {
        throw Exception('CEP não encontrado');
      }
      if (!mounted) return;
      setState(() {
        rua.text = dados['logradouro'] ?? '';
        bairro.text = dados['bairro'] ?? '';
        cidade.text = dados['localidade'] ?? '';
        estado.text = dados['uf'] ?? '';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => erroCep = 'Não foi possível encontrar esse CEP.');
    } finally {
      if (mounted) setState(() => buscandoCep = false);
    }
  }

  void salvar() {
    if (!_formKey.currentState!.validate()) return;
    final pessoa = Pessoa(
      nome: nome.text.trim(),
      cep: cep.text.trim(),
      rua: rua.text.trim(),
      bairro: bairro.text.trim(),
      cidade: cidade.text.trim(),
      estado: estado.text.trim(),
      numero: numero.text.trim(),
      complemento: complemento.text.trim(),
    );
    Navigator.pop(context, pessoa);
  }

  InputDecoration decoracao(String label, {String? hint, Widget? suffixIcon}) {
    return InputDecoration(labelText: label, hintText: hint, suffixIcon: suffixIcon);
  }

  String? obrigatorio(String? value) => value == null || value.trim().isEmpty ? 'Preencha este campo' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(editando ? 'Editar pessoa' : 'Cadastre-se')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
          children: [
            Text(
              editando ? 'Atualize os dados do cadastro' : 'Novo cadastro',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            TextFormField(controller: nome, textInputAction: TextInputAction.next, decoration: decoracao('Nome'), validator: obrigatorio),
            const SizedBox(height: 12),
            TextFormField(
              controller: cep,
              keyboardType: TextInputType.number,
              maxLength: 9,
              decoration: decoracao(
                'CEP',
                hint: '00000-000',
                suffixIcon: buscandoCep
                    ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.search),
              ).copyWith(counterText: ''),
              inputFormatters: [],
              validator: (value) {
                final limpo = value?.replaceAll(RegExp(r'\D'), '') ?? '';
                if (limpo.length != 8) return 'Digite um CEP válido';
                return null;
              },
              onChanged: (value) {
                final digits = value.replaceAll(RegExp(r'\D'), '');
                if (digits.length == 8 && !value.contains('-')) {
                  cep.text = '${digits.substring(0, 5)}-${digits.substring(5)}';
                  cep.selection = TextSelection.collapsed(offset: cep.text.length);
                }
              },
            ),
            if (erroCep != null) ...[
              const SizedBox(height: 4),
              Text(erroCep!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 12),
            TextFormField(controller: rua, readOnly: true, decoration: decoracao('Rua:')),
            const SizedBox(height: 12),
            TextFormField(controller: bairro, readOnly: true, decoration: decoracao('Bairro:')),
            const SizedBox(height: 12),
            TextFormField(controller: cidade, readOnly: true, decoration: decoracao('Cidade:')),
            const SizedBox(height: 12),
            TextFormField(controller: estado, readOnly: true, decoration: decoracao('Estado:')),
            const SizedBox(height: 12),
            TextFormField(controller: numero, keyboardType: TextInputType.number, textInputAction: TextInputAction.next, decoration: decoracao('Número'), validator: obrigatorio),
            const SizedBox(height: 12),
            TextFormField(controller: complemento, textInputAction: TextInputAction.done, decoration: decoracao('Complemento')),
            const SizedBox(height: 24),
            ElevatedButton.icon(onPressed: salvar, icon: const Icon(Icons.save), label: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
