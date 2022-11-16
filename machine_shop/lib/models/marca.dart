class Marca {
  int? id;
  String nombre = '';
  String procedencia = '';

  Marca({required this.id, required this.nombre});

  Marca.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    procedencia = json['procedencia'];
  }
}
