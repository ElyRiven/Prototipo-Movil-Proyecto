import 'package:flutter/material.dart';
import 'package:prototipo_movil_proyecto/benefits/requests/benefits_requests.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/benefits_screen.dart';
import 'package:prototipo_movil_proyecto/products/models/product_model.dart';
import 'package:prototipo_movil_proyecto/products/screens/products_screen.dart';
import 'package:prototipo_movil_proyecto/trips/screens/active_trip_itinerary_screen.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class ActiveTripScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  final int productId;
  const ActiveTripScreen(
      {super.key,
      required this.userId,
      required this.csrfToken,
      required this.productId});

  @override
  State<ActiveTripScreen> createState() => _ActiveTripScreenState();
}

class _ActiveTripScreenState extends State<ActiveTripScreen> {
  int _selectedIndex = 1;
  Product? activeProduct;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 1;
    getProduct(widget.productId).then((value) {
      setState(() {
        activeProduct = value;
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserScreen(
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
              const Text(
                "VIAJE ACTIVO",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                activeProduct?.name ?? "Cargando...",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ActiveTripItineraryScreen(
                              userId: widget.userId,
                              csrfToken: widget.csrfToken,
                              productId: widget.productId,
                            )),
                  );
                },
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan,
                        width: 3.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    constraints: const BoxConstraints(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.description),
                          title: const Text("Descripción:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            activeProduct?.description ?? "Cargando...",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.place),
                          title: const Text("País Destino:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            activeProduct?.country ?? "Cargando...",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.price_change),
                          title: const Text("Precio:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            "\$${activeProduct?.price ?? "Cargando..."}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.date_range),
                          title: const Text("Fecha de Inicio:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            activeProduct?.startDate ?? "Cargando...",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.date_range),
                          title: const Text("Fecha de Fin:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            activeProduct?.endDate ?? "Cargando...",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    )),
              ),
            ])),
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
