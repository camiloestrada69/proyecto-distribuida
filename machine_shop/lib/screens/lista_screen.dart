import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:machine_shop/helpers/constants.dart';
import 'package:machine_shop/models/cliente.dart';
import 'package:machine_shop/screens/formulario_creacion_cliente.dart';
import 'package:http/http.dart' as http;

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  final List<String> _names = [
    'Liam',
    'Noah',
    'Oliver',
    'William',
    'Elijah',
    'James',
    'Benjamin',
    'Lucas',
    'Mason',
    'Ethan',
    'Alexander'
  ];
  List<Cliente> _clientes = [];
  @override
  Widget build(BuildContext context) {
    _listarClientes();
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Demo'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 194, 199, 226),
      body: Stack(children: <Widget>[_listaBuilder(), _showButtonAdd()]),
    );
  }

  Widget _listaBuilder() {
    print(_clientes);
    return ListView.builder(
      itemBuilder: (_, i) {
        String name = _clientes[i].nombre;
        String cedula = _clientes[i].cedula;
        return Card(
          child: ListTile(
            leading: FlutterLogo(),
            title: Text(name),
            subtitle: Text(cedula),
            trailing: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'Editar',
                    child: Text('Editar'),
                  ),
                  PopupMenuItem(
                    value: 'eliminar',
                    child: Text('Eliminar'),
                  )
                ];
              },
              onSelected: (String value) {
                print('You Click on po up menu item');
              },
            ),
          ),
        );
      },
      itemCount: _clientes.length,
    );
  }

  Widget _showButtonAdd() {
    return FloatingActionButton(
      backgroundColor: const Color(0xff03dac6),
      foregroundColor: Colors.black,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FormularioCreacionCliente())); // Respond to button press
      },
      child: Icon(Icons.add),
    );
  }

  void _listarClientes() async {
    var url = Uri.parse('${Constants.apiUrl}clientes');
 
    var response = await http.get(
      url, 
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
    );

    var body = jsonDecode(response.body);
    var lista =
        List<Cliente>.from(body.map((model) => Cliente.fromJson(model)));
    _clientes = lista;
  }
}
