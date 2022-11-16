import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:machine_shop/screens/lista_screen.dart';

import '../helpers/constants.dart';

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  String _emial = '';
  String _password = '';
  bool _passworShow = false;
  bool _rememberme = true;
  String _emailError = '';
  bool _emailShowError = false;
  String _passwordError = '';
  bool _passwordShowError = false;
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
              _emailTexfield(),
              _passwordTexfield(),
              _showButtons()
            ],
          ),
        ));
  }

  Widget _emailTexfield() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Digite su nombre...',
          errorText: _emailShowError ? _emailError : null,
          labelText: 'Nombre',
          border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
      onChanged: (value) {
        _emial = value;
      },
    );
  }

  Widget _passwordTexfield() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Digite su apellido...',
           errorText: _passwordShowError ? _passwordError : null,
          labelText: 'Apellido',
          border: OutlineInputBorder(borderRadius: BorderRadius.zero)),
      onChanged: (value) {
        _password = value;
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
        child: Text('Crear'),
        style: ButtonStyle(backgroundColor:
            MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
          return Color.fromARGB(255, 32, 15, 23);
        })),
        onPressed: (() => _register()),
      ),
    );
  }

  bool _validateFields() {
    bool isValid = true;
    if (_emial.isEmpty) {
      isValid = false;
      _emailError = 'El email es obligatorio';
      _emailShowError = true;
    } else if (!EmailValidator.validate(_emial)) {
      isValid = false;
      _emailError = 'El email es invalido';
      _emailShowError = true;
    } else {
      _emailShowError = false;
    }
    if (_password.isEmpty) {
      isValid = false;
      _passwordError = 'El password es obligatorio';
      _passwordShowError = true;
    } else if (_password.length < 6) {
      isValid = false;
      _passwordError = 'El password debe contener mas de 6 caracteres';
      _passwordShowError = true;
    } else {
      _passwordShowError = false;
    }
    setState(() {});
    return isValid;
  }

  void _register() async {
    if (!_validateFields()) {
      return;
    }

    Map<String, dynamic> request = {
      'email': _emial,
      'password': _password,
    };
    var url = Uri.parse('${Constants.apiUrl}cuentas/registrar');
    var response = await http.post(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(request),
    );
    setState(() {
      _passworShow = false;
    });
    if (response.body.isNotEmpty) {
        Future.delayed(Duration.zero, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Lista()),
      );
    });
    }
  }
}
