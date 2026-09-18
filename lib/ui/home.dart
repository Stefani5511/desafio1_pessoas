import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../root/file.dart';
import 'cadastro.dart';
import 'style/colors.dart';
import 'style/theme.dart';
import 'splash.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Pessoa> pessoas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    final dados = await GerenciarArquivo.abrir();
    if (!mounted) return;
    setState(() {
      pessoas = dados;
      carregando = false;
    });
  }

  Future<void> salvarDados() async {
    await GerenciarArquivo.salvar(pessoas);
  }

  Future<void> abrirCadastro() async {
    final pessoa = await Navigator.push<Pessoa>(
      context,
      MaterialPageRoute(builder: (_) => const Cadastro()),
    );
    if (pessoa == null) return;
    setState(() => pessoas.add(pessoa));
    await salvarDados();
  }

  Future<void> editarPessoa(int index) async {
    final pessoa = await Navigator.push<Pessoa>(
      context,
      MaterialPageRoute(builder: (_) => Cadastro(pessoa: pessoas[index])),
    );
    if (pessoa == null) return;
    setState(() => pessoas[index] = pessoa);
    await salvarDados();
  }

  Future<void> excluirPessoa(int index) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir cadastro'),
        content: Text('Deseja excluir o cadastro de ${pessoas[index].nome}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (confirmar != true) return;
    setState(() => pessoas.removeAt(index));
    await salvarDados();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: AppTheme.modo,
            builder: (_, modo, __) => IconButton(
              tooltip: 'Alternar tema',
              onPressed: AppTheme.alternarTema,
              icon: Icon(modo == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : pessoas.isEmpty
              ? _vazio()
              : RefreshIndicator(
                  onRefresh: carregarDados,
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
                    itemCount: pessoas.length,
                    itemBuilder: (_, index) => _cardPessoa(index),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirCadastro,
        tooltip: 'Novo cadastro',
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final escuro = AppTheme.modo.value == ThemeMode.dark;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(color: AppColors.azul),
              accountName: const Text('Pessoas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              accountEmail: const Text('Cadastro de pessoas'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(padding: const EdgeInsets.all(10), child: Image.asset('assets/icone.png')),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Pessoas'),
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Novo cadastro'),
              onTap: () {
                Navigator.pop(context);
                abrirCadastro();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: const Text('Splash'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const Splash()),
                );
              },
            ),
            SwitchListTile(
              secondary: Icon(escuro ? Icons.dark_mode : Icons.light_mode),
              title: const Text('Tema escuro'),
              value: escuro,
              onChanged: (value) => AppTheme.modo.value = value ? ThemeMode.dark : ThemeMode.light,
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Voltar'),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _vazio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 82, color: Theme.of(context).colorScheme.primary.withOpacity(.55)),
            const SizedBox(height: 18),
            const Text('Nenhuma pessoa cadastrada', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Toque no botão + para adicionar o primeiro cadastro.', textAlign: TextAlign.center),
            const SizedBox(height: 22),
            FilledButton.icon(onPressed: abrirCadastro, icon: const Icon(Icons.add), label: const Text('Cadastrar pessoa')),
          ],
        ),
      ),
    );
  }

  Widget _cardPessoa(int index) {
    final pessoa = pessoas[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => editarPessoa(index),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  pessoa.nome.isEmpty ? '?' : pessoa.nome.substring(0, 1).toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pessoa.nome, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('CEP: ${pessoa.cep}', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Excluir',
                onPressed: () => excluirPessoa(index),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
