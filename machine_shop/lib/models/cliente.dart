class Cliente {
  int? id;
  String cedula = '';
  String nombre = '';
  String apellido = '';
  String telefono = '';
  String direccion = '';
  String tipoCuenta = '';
  double monto = 0;
  String urlImage = '';

  Cliente({required this.id, required this.cedula, required this.nombre, required this.apellido, required this.telefono, required this.direccion, required this.tipoCuenta, required this.monto, required this.urlImage});

  Cliente.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cedula = json['cedula'];
    nombre = json['nombre'];
    apellido = json['apellido'];
    telefono = json['telefono'];
    direccion = json['direccion'];
    tipoCuenta = json['apellido'];
    apellido = json['apellido'];
  }
}
