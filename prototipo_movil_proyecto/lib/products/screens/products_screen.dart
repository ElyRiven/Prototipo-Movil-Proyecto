import 'package:flutter/material.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/benefits_screen.dart';
import 'package:prototipo_movil_proyecto/trips/screens/trips_screen.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class ProductScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  const ProductScreen(
      {super.key, required this.userId, required this.csrfToken});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _selectedIndex = 2;

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
    } else if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserScreen(
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Pantalla Productos'),
          ],
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
