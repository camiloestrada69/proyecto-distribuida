import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:machine_shop/helpers/constants.dart';
import 'package:http/http.dart' as http;
import 'package:machine_shop/models/cliente.dart';
import 'package:machine_shop/screens/lista_screen.dart';

class FormularioCreacionCliente extends StatefulWidget {
  const FormularioCreacionCliente({super.key});

  @override
  State<FormularioCreacionCliente> createState() =>
      _FormularioCreacionClienteState();
}

class _FormularioCreacionClienteState extends State<FormularioCreacionCliente> {
  String _cedula = '';
  String _nombre = '';
  String _apellido = '';
  String _telefono = '';
  String _direccion = '';
  String _tipoCuenta = '';
  double _monto = 0;

  bool _cedulaShowError = false;
  bool _nombreShowError = false;
  bool _apellidoShowError = false;
  bool _telefonoShowError = false;
  bool _direccionShowError = false;
  bool _tipoCuentaShowError = false;
  bool _montoShowError = false;

  String _cedulaError = '';
  String _nombreError = '';
  String _apellidoError = '';
  String _telefonoError = '';
  String _direccionError = '';
  String _tipoCuentaError = '';
  String _montoError = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 199, 226),
      appBar: AppBar(
        title: const Text('Formulario'),
      ),
      body: _form(),
    ); // Crea un widget Form usando el _formKey que creamos anteriormente
  }

  Widget _form() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _cedulaTexfield(),
              _nombreTexField(),
              _apellidoTextField(),
              _telefonoTextField(),
              _direccionTextField(),
              _tipoCuentaTextField(),
              _montoTextField(),
              _showButtons()
            ],
          ),
        ));
  }

  Widget _cedulaTexfield() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Digite su cedula...',
          errorText: _cedulaShowError ? _cedulaError : null,
          labelText: 'Cedula',
          border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
      onChanged: (value) {
        _cedula = value;
      },
    );
  }

  Widget _nombreTexField() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Digite su nombre...',
          errorText: _nombreShowError ? _nombreError : null,
          labelText: 'Nombre',
          border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
      onChanged: (value) {
        _nombre = value;
      },
    );
  }

  Widget _apellidoTextField() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Digite su apellido...',
          errorText: _apellidoShowError ? _apellidoError : null,
          labelText: 'Apellido',
          border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
      onChanged: (value) {
        _apellido = value;
      },
    );
  }

  Widget _telefonoTextField() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Digite su telefono...',
          errorText: _telefonoShowError ? _telefonoError : null,
          labelText: 'Telefono',
          border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
      onChanged: (value) {
        _telefono = value;
      },
    );
  }

  Widget _direccionTextField() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Digite su dirección...',
          errorText: _direccionShowError ? _direccionError : null,
          labelText: 'Dirección',
          border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
      onChanged: (value) {
        _direccion = value;
      },
    );
  }

  Widget _tipoCuentaTextField() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Digite su tipo cuenta...',
          errorText: _tipoCuentaShowError ? _tipoCuentaError : null,
          labelText: 'Tipo cuenta',
          border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
      onChanged: (value) {
        _tipoCuenta = value;
      },
    );
  }

  Widget _montoTextField() {
    return TextField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Digite monto...',
          errorText: _montoShowError ? _montoError : null,
          labelText: 'Monto',
          border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
      onChanged: (value) {
        _monto = value != '' ? double.parse(value) : 0;
      },
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _showLoginButton(),
          ],
        )
      ]),
    );
  }

  Widget _showLoginButton() {
    return Expanded(
      child: ElevatedButton(
        child: Text('Crear cliente'),
        style: ButtonStyle(backgroundColor:
            MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
          return Color.fromARGB(255, 32, 15, 23);
        })),
        onPressed: (() => crearCliente()),
      ),
    );
  }

  bool _validateFields() {
    bool isValid = true;
    if (_cedula.isEmpty) {
      isValid = false;
      _cedulaError = 'La cedula es obligatorio';
      _cedulaShowError = true;
    }
    if (_nombre.isEmpty) {
      isValid = false;
      _nombreError = 'El nombre es obligatorio';
      _nombreShowError = true;
    }
    if (_apellido.isEmpty) {
      isValid = false;
      _apellidoError = 'El apellido es obligatorio';
      _apellidoShowError = true;
    }
    if (_telefono.isEmpty) {
      isValid = false;
      _telefonoError = 'El telefono es obligatorio';
      _telefonoShowError = true;
    }
    if (_direccion.isEmpty) {
      isValid = false;
      _direccionError = 'El direccion es obligatorio';
      _cedulaShowError = true;
    }
    if (_monto == 0) {
      isValid = false;
      _montoError = 'El monto es obligatorio';
      _montoShowError = true;
    }
    setState(() {});
    return isValid;
  }

  void crearCliente() async {
    if (!_validateFields()) {
      return;
    }
    Map<String, dynamic> request = {
      'cedula': _cedula,
      'nombre': _nombre,
      'apellido': _apellido,
      'telefono': _telefono,
      'direccion': _direccion,
      'tipoCuenta': _tipoCuenta,
      'monto': _monto,
    };

    var url = Uri.parse('${Constants.apiUrl}clientes');
    var response = await http.post(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(request),
    );

      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Lista()),
        );
      });
  }
}
