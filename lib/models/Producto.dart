class Producto {
  String id;
  String nombre;
  String descripcion;
  String imagen;
  int cantidad_disponible;

  Producto(
      {required this.id,
      required this.nombre,
      required this.descripcion,
      required this.imagen,
      required this.cantidad_disponible});

  //getCantidadDisponible() => cantidad_disponible;
  int get getcantidad_disponible {
    return cantidad_disponible;
  }
}
