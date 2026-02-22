class Estudiante {
  int? id;
  String nombre;
  int edad;

  Estudiante({this.id, required this.nombre, required this.edad});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'edad': edad};
  }

  factory Estudiante.fromMap(Map<String, dynamic> map) {
    return Estudiante(id: map['id'], nombre: map['nombre'], edad: map['edad']);
  }
}
