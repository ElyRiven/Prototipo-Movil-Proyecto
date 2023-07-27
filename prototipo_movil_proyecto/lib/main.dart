import 'package:flutter/material.dart';
import 'package:prototipo_movil_proyecto/users/screens/login_screen.dart';
// import 'package:prototipo_movil_proyecto/users/screens/counter_screen.dart';

void main() {
  runApp(const MobilePrototype());
}

class MobilePrototype extends StatelessWidget {
  const MobilePrototype({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.purple),
        home: const LoginScreen());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue));
  }
}
