import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/benefits_screen.dart';
import 'package:prototipo_movil_proyecto/products/requests/product_requests.dart';
import 'package:prototipo_movil_proyecto/products/screens/products_screen.dart';
import 'package:prototipo_movil_proyecto/trips/screens/trips_screen.dart';
import 'package:prototipo_movil_proyecto/users/models/user_model.dart';
import 'package:prototipo_movil_proyecto/users/requests/user_requests.dart';
import 'package:prototipo_movil_proyecto/users/screens/edit_user_screen.dart';

class UserScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  const UserScreen({super.key, required this.userId, required this.csrfToken});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _selectedIndex = 0;
  User? user;
  DateTime defaultDate = DateTime(2000, 1, 1);

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    getUser(widget.userId).then((value) {
      setState(() {
        user = value;
        if (user!.firstLogin == defaultDate) {
          String firstLoginDate =
              DateFormat('yyyy-MM-dd').format(DateTime.now());
          saveFirstLogin(widget.userId, firstLoginDate, widget.csrfToken);
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('¡Bienvenido!'),
                content: const Text(
                    'Es tu primera vez en la aplicación\n ¡Gracias por viajar con nosotros!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        } else if (checkBenefitReset(user!.firstLogin)) {
          String firstLoginDate =
              DateFormat('yyyy-MM-dd').format(DateTime.now());
          resetBenefits(widget.userId, widget.csrfToken);
          resetPoints(widget.userId, widget.csrfToken);
          saveFirstLogin(widget.userId, firstLoginDate, widget.csrfToken);
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Beneficios Reiniciados'),
                content: const Text(
                    'Han pasado 6 meses, tus beneficios han sido reiniciados\n¡Gracias por viajar con nosotros!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  bool checkBenefitReset(DateTime firstLogin) {
    final now = DateTime.now();
    final difference = now.difference(firstLogin);
    const sixMonths = Duration(days: 6 * 30);
    return difference >= sixMonths;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripScreen(
            userId: widget.userId,
            csrfToken: widget.csrfToken,
          ),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductScreen(
            userId: widget.userId,
            csrfToken: widget.csrfToken,
          ),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BenefitScreen(
            userId: widget.userId,
            csrfToken: widget.csrfToken,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset('assets/images/logo_text.png'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('PERFIL DE USUARIO',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.lightGreen,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.email),
                    const SizedBox(width: 10),
                    Text(
                      'Correo: ${user?.email.toLowerCase() ?? ''}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.key),
                    SizedBox(width: 10),
                    Text(
                      'Contraseña: **********',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.perm_identity),
                    const SizedBox(width: 10),
                    Text(
                      'Identificación: ${user?.idNumber ?? ''}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.phone_android),
                    const SizedBox(width: 10),
                    Text(
                      'Telefono: ${user?.phoneNumber ?? ''}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.star_half),
                    const SizedBox(width: 10),
                    Text(
                      'Puntos: ${user?.points ?? ''}',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditUserScreen(
                                    userId: widget.userId,
                                    csrfToken: widget.csrfToken,
                                    user: user,
                                  )),
                        );
                      },
                      child: const Text('Editar perfil'))),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blue,
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.copyWith(
                bodySmall: const TextStyle(color: Colors.white),
              ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Usuario',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              label: 'Viajes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.airplane_ticket),
              label: 'Productos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Beneficios',
            ),
          ],
        ),
      ),
    );
  }
}
