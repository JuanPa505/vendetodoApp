import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vendetodo/models/Producto.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Producto>> _listaProductos;

  Future<List<Producto>> getProductos() async {
    //Modificar url del responde para prueba local.
    final response =
        await http.get(Uri.parse('http://74.208.181.167/api/listaProductos'));
    List<Producto> listaProductos = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData['data']) {
        listaProductos.add(Producto(
            id: item['producto_nombre'],
            nombre: item['producto_nombre'],
            descripcion: item['proveedor_nombre'],
            imagen: item['producto_imagen'].toString(),
            cantidad_disponible: item['cantidad_disponible']));
      }
      return listaProductos;
    } else {
      throw Exception("Error al obtener los productos");
    }
  }

  @override
  void initState() {
    super.initState();
    _listaProductos = getProductos();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vende Todo App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Catalogo de Productos',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 100, 126, 241),
          elevation: 0.0,
        ),
        body: FutureBuilder(
          future: _listaProductos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 54, 104, 255),
                    ),
                    child: ListTile(
                      title: Text(snapshot.data![index].nombre,
                          style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(snapshot.data![index].descripcion,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Roboto',
                          )),
                      //snapshot.data![index].imagen,
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          child: Image.network(snapshot.data![index].imagen,
                              fit: BoxFit.contain, width: 80, height: 80),
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: Colors.white),
                      contentPadding: const EdgeInsets.all(10),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetalleProducto(
                                    producto: snapshot.data![index])));
                      },
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class DetalleProducto extends StatelessWidget {
  final Producto producto;

  const DetalleProducto({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(producto.nombre,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 100, 126, 241),
      ),
      body: Center(
        child: Column(children: [
          const Padding(padding: EdgeInsets.all(10)),
          ClipRRect(
            borderRadius: BorderRadius.circular(25), // Image border
            child: SizedBox.fromSize(
              child: Image.network(producto.imagen,
                  fit: BoxFit.contain, width: 380, height: 350),
            ),
          ),
          const Padding(padding: EdgeInsets.all(15)),
          Container(
            width: 330,
            height: 100,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 54, 104, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text.rich(
              textAlign: TextAlign.center,
              TextSpan(
                text: 'Producto: ',
                style: const TextStyle(
                    fontSize: 20, color: Colors.white), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: producto.nombre,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          const Padding(padding: EdgeInsets.all(10)),
          Container(
            width: 320,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 54, 104, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text.rich(
              TextSpan(
                text: 'Disponibilidad: ',
                style: const TextStyle(
                    fontSize: 20, color: Colors.white), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: producto.cantidad_disponible.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
        ]),
      ),
    );
  }
}
