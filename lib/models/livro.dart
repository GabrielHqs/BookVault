/// Entidade do app. Não depende de Flutter nem de Firestore.
class Livro {
  const Livro({
    this.id,
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.nota,
    required this.lido,
    required this.criadoEm,
  });

  final String? id;
  final String titulo;
  final String autor;
  final String genero;
  final int nota;
  final bool lido;
  final DateTime criadoEm;

  factory Livro.fromMap(Map<String, dynamic> map, String id) {
    return Livro(
      id: id,
      titulo: map['titulo'] as String? ?? '',
      autor: map['autor'] as String? ?? '',
      genero: map['genero'] as String? ?? '',
      nota: (map['nota'] as num?)?.toInt() ?? 0,
      lido: map['lido'] as bool? ?? false,
      criadoEm:
          DateTime.tryParse(map['criadoEm'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'autor': autor,
      'genero': genero,
      'nota': nota,
      'lido': lido,
      'criadoEm': criadoEm.toIso8601String(),
    };
  }
}
