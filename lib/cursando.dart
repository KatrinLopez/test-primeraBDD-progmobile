class Cursando {
  int? id;
  int estudanteId;
  int disciplinaId;

  Cursando({
    this.id,
    required this.estudanteId,
    required this.disciplinaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'estudante_id': estudanteId,
      'disciplina_id': disciplinaId,
    };
  }

  factory Cursando.fromMap(Map<String, dynamic> map) {
    return Cursando(
      id: map['id'],
      estudanteId: map['estudante_id'],
      disciplinaId: map['disciplina_id'],
    );
  }
}