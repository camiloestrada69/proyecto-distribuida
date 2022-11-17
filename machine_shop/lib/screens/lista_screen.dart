import 'dart:convert';

import 'package:flutter/material.dart';
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
    //_listarClientes();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de clientes'),
      ),
      backgroundColor: Color.fromARGB(255, 194, 199, 226),
      body: Stack(children: <Widget>[
         FutureBuilder(
            future: _dataList(),
            builder: (_, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              return ListView(
                children: snapshot.data,
              );
            }),
        _showButtonAdd()
        ]),
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

  Future<List<Cliente>> _listarClientes() async {
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
    return _clientes;
  }

  Future<List<Widget>> _dataList() async {
    final List<Cliente> clinetesResponse = await _listarClientes();
    return clinetesResponse
        .map((n) => Card(
          child: ListTile(
            leading: FlutterLogo(),
            title: Text(n.nombre),
            subtitle: Text(n.cedula),
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
        )   )
        .toList();
  }
}
