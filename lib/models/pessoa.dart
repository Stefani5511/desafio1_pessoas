class Pessoa {
  final String nome;
  final String cep;
  final String rua;
  final String bairro;
  final String cidade;
  final String estado;
  final String numero;
  final String complemento;

  const Pessoa({
    required this.nome,
    required this.cep,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.numero,
    required this.complemento,
  });

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'cep': cep,
        'rua': rua,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
        'numero': numero,
        'complemento': complemento,
      };

  factory Pessoa.fromJson(Map<String, dynamic> json) => Pessoa(
        nome: json['nome'] ?? '',
        cep: json['cep'] ?? '',
        rua: json['rua'] ?? '',
        bairro: json['bairro'] ?? '',
        cidade: json['cidade'] ?? '',
        estado: json['estado'] ?? '',
        numero: json['numero'] ?? '',
        complemento: json['complemento'] ?? '',
      );
}
