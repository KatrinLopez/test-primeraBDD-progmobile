class estudante {
  int? id;
  String nome;
  String matricula;

  estudante({this.id, required this.nome, required this.matricula});

  Map<String, dynamic> toMap(){
    return {"id": id, "nome": nome, "matricula": matricula};
  }

  factory estudante.fromMap(Map<String, dynamic> map){
    return estudante(
      id: map['id'],
      nome: map['nome'],
      matricula: map['matricula'],
    );
  }
}