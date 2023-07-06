import 'package:flutter/material.dart';
//import 'package:prototipo_movil_proyecto/users/screens/counter_screen.dart';
import 'package:prototipo_movil_proyecto/users/requests/login_requests.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
          child: Column(
        children: [
          const SizedBox(height: 250.0),
          SizedBox(
            width: 500.0,
            child: Image.asset('assets/images/logo_text.png'),
          ),
          const SizedBox(height: 30.0),
          const Text(
            "LOGIN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          const SizedBox(height: 30.0),
          SizedBox(
            width: 250.0,
            child: TextField(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: 250.0,
            child: TextField(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          SizedBox(
            width: 250.0,
            child: ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                String errorMessage = '';
                login(username, password).then((value) {
                  if (value != 0) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserScreen(userId: value),
                        ));
                  } else {
                    errorMessage = 'Usuario y/o contraseña incorrectos';
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: Text(errorMessage),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'))
                            ],
                          );
                        });
                  }
                });
              },
              child: const Text('INGRESAR'),
            ),
          ),
          const SizedBox(height: 15.0),
        ],
      )),
    ));
  }
}
