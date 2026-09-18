import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/pessoa.dart';

abstract class GerenciarArquivo {
  static Future<File> _arquivo() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/pessoas.json');
  }

  static Future<List<Pessoa>> abrir() async {
    try {
      final arquivo = await _arquivo();
      if (!await arquivo.exists()) return [];
      final conteudo = await arquivo.readAsString();
      if (conteudo.trim().isEmpty) return [];
      final lista = jsonDecode(conteudo) as List<dynamic>;
      return lista
          .map((item) => Pessoa.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> salvar(List<Pessoa> pessoas) async {
    final arquivo = await _arquivo();
    await arquivo.writeAsString(jsonEncode(pessoas.map((p) => p.toJson()).toList()));
  }
}
