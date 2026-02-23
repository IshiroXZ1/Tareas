class Recordatorio {
  final String id;
  final String texto;
  final bool completado;
  final String fecha;

  Recordatorio({
    required this.id,
    required this.texto,
    required this.completado,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'texto': texto, 'completado': completado, 'fecha': fecha};
  }

  factory Recordatorio.fromMap(Map<String, dynamic> map) {
    return Recordatorio(
      id: map['id'],
      texto: map['texto'],
      completado: map['completado'],
      fecha: map['fecha'],
    );
  }

  Recordatorio copyWith({bool? completado}) {
    return Recordatorio(
      id: id,
      texto: texto,
      completado: completado ?? this.completado,
      fecha: fecha,
    );
  }
}
