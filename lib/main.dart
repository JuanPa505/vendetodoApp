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
          title: const Text('Vende Todo App'),
        ),
        body: FutureBuilder(
          future: _listaProductos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _listProductos(snapshot.data),
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

  List<Widget> _listProductos(List<Producto>? data) {
    List<Widget> productos = [];

    for (var producto in data!) {
      productos.add(Card(
          child: Column(
        children: [
          Image.network(producto.imagen),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(producto.nombre),
          ),
        ],
      )));
    }
    return productos;
  }
}
