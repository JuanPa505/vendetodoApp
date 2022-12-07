import 'dart:async';
import 'dart:convert';
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
    final response =
        await http.get(Uri.parse('https://valorant-api.com/v1/bundles'));
    List<Producto> listaProductos = [];
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData['data']) {
        listaProductos.add(Producto(
            id: item['uuid'],
            nombre: item['displayName'],
            descripcion: item['description'],
            imagen: item['displayIcon']));
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
                  return ListTile(
                    title: Text(snapshot.data![index].nombre),
                    subtitle: Text(snapshot.data![index].descripcion),
                    //snapshot.data![index].imagen,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10), // Image border
                      child: SizedBox.fromSize(
                        child: Image.network(snapshot.data![index].imagen,
                            fit: BoxFit.cover, width: 80, height: 80),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    contentPadding: const EdgeInsets.all(10),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetalleProducto(
                                  producto: snapshot.data![index])));
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text("Error");
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
                  fit: BoxFit.cover, width: 380, height: 300),
            ),
          ),
          const Padding(padding: EdgeInsets.all(15)),
          Container(
            width: 300,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 98, 174),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text.rich(
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
          Container(
            width: 300,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 36, 98, 174),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text.rich(
              TextSpan(
                text: 'Descripción: ',
                style: const TextStyle(
                    fontSize: 20, color: Colors.white), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: producto.descripcion,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          Container(
            width: 320,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 98, 174),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text.rich(
              TextSpan(
                text: 'Disponibilidad: ',
                style: TextStyle(
                    fontSize: 20, color: Colors.white), // default text style
                children: <TextSpan>[
                  TextSpan(
                      text: "# de unidades",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
