// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:machine_shop/helpers/constants.dart';
import 'package:http/http.dart' as http;
import 'package:machine_shop/models/token.dart';
import 'package:machine_shop/screens/formulario_screen.dart';
import 'package:machine_shop/screens/lista_screen.dart';
import 'package:machine_shop/screens/register_user_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //TODO: Declaracion de variables globales de la clase
  String _emial = '';
  String _password = '';
  bool _passworShow = false;
  bool _rememberme = true;
  String _emailError = '';
  bool _emailShowError = false;
  String _passwordError = '';
  bool _passwordShowError = false;
  late Token _token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 194, 199, 226),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //_grid(),
          _showlogo(),
          _shoemail(),
          _shopassword(),
          _showRememberme(),
          _showButtons()
        ],
      )),
    );
  }

  Widget _showlogo() {
    return Image(
      image: AssetImage('images/logo-bank.png'),
      width: 300,
      fit: BoxFit.fill,
    );
  }

  Widget _shoemail() {
    // ignore: avoid_unnecessary_containers
    return Container(
      padding: EdgeInsets.all(20),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Digite su email...',
            labelText: 'Email',
            errorText: _emailShowError ? _emailError : null,
            prefixIcon: Icon(Icons.alternate_email),
            suffixIcon: Icon(Icons.email),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _emial = value;
        },
      ),
    );
  }

  Widget _shopassword() {
    // ignore: avoid_unnecessary_containers
    return Container(
      padding: EdgeInsets.all(20),
      child: TextField(
        obscureText: _passworShow,
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Digite su password...',
            labelText: 'Password',
            errorText: _passwordShowError ? _passwordError : null,
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: !_passworShow
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passworShow = !_passworShow;
                });
              },
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget _showRememberme() {
    return CheckboxListTile(
        title: Text('Remember me!'),
        value: _rememberme,
        onChanged: (((value) {
          setState(() {
            _rememberme = value!;
          });
        })));
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _showLoginButton(),
            SizedBox(width: 20),
            _showRegisterButton(),
            SizedBox(width: 20),
            _showListButton()
          ],
        )
      ]),
    );
  }

  Widget _showLoginButton() {
    return Expanded(
      child: ElevatedButton(
        child: Text('Login'),
        style: ButtonStyle(backgroundColor:
            MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
          return Color.fromARGB(255, 32, 15, 23);
        })),
        onPressed: (() => _login()),
      ),
    );
  }

  Widget _showListButton() {
    return Expanded(
      child: ElevatedButton(
        child: Text('Lista'),
        style: ButtonStyle(backgroundColor:
            MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
          return Color.fromARGB(255, 32, 15, 23);
        })),
        onPressed: (() => {
              Future.delayed(Duration.zero, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Lista()),
                );
              })
            }),
      ),
    );
  }

  void _login() async {
    log('entro al login');
    if (!_validateFields()) {
      return;
    }

    Map<String, dynamic> request = {
      'email': _emial,
      'password': _password,
    };
    var url = Uri.parse('${Constants.apiUrl}cuentas/login/');
    var response = await http.post(
      url,
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      },
      body: jsonEncode(request),
    );
    print(response.body);
    print(jsonDecode(response.body));
    Token token1 = Token.fromJson(jsonDecode(response.body));
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

  Widget _showRegisterButton() {
    return Expanded(
      child: ElevatedButton(
        child: Text('Register'),
        style: ButtonStyle(backgroundColor:
            MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
          return Color.fromARGB(255, 52, 46, 133);
        })),
        onPressed: (() => {
              Future.delayed(Duration.zero, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Formulario()),
                );
              })
            }),
      ),
    );
  }

  void _register() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterUserScreen()));
  }

  RegisterUserScreen() {
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => RegisterUserScreen()));
  }

  Widget _grid() {
    return ListView(
      children: const <Widget>[
        Card(child: ListTile(title: Text('One-line ListTile'))),
        Card(
          child: ListTile(
            leading: FlutterLogo(),
            title: Text('One-line with leading widget'),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('One-line with trailing widget'),
            trailing: Icon(Icons.more_vert),
          ),
        ),
        Card(
          child: ListTile(
            leading: FlutterLogo(),
            title: Text('One-line with both widgets'),
            trailing: Icon(Icons.more_vert),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('One-line dense ListTile'),
            dense: true,
          ),
        ),
        Card(
          child: ListTile(
            leading: FlutterLogo(size: 56.0),
            title: Text('Two-line ListTile'),
            subtitle: Text('Here is a second line'),
            trailing: Icon(Icons.more_vert),
          ),
        ),
        Card(
          child: ListTile(
            leading: FlutterLogo(size: 72.0),
            title: Text('Three-line ListTile'),
            subtitle:
                Text('A sufficiently long subtitle warrants three lines.'),
            trailing: Icon(Icons.more_vert),
            isThreeLine: true,
          ),
        ),
      ],
    );
  }
}
