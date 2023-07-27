import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prototipo_movil_proyecto/benefits/models/user_product_model.dart';
import 'package:prototipo_movil_proyecto/benefits/requests/benefits_requests.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/benefits_screen.dart';
import 'package:prototipo_movil_proyecto/products/models/product_model.dart';
import 'package:prototipo_movil_proyecto/products/screens/products_screen.dart';
import 'package:prototipo_movil_proyecto/trips/requests/trips_requests.dart';
import 'package:prototipo_movil_proyecto/trips/screens/active_trip_screen.dart';
import 'package:prototipo_movil_proyecto/trips/screens/trips_itinerary_screen.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class TripScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  const TripScreen({super.key, required this.userId, required this.csrfToken});

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  int _selectedIndex = 1;
  List<Product> endedTrips = [];
  UserProduct? activeTrip;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 1;
    getEndedTrips(widget.userId).then((value) {
      setState(() {
        endedTrips = value;
      });
    });
    checkTrip(widget.userId).then((value) {
      setState(() {
        activeTrip = value;
        if (value.code != 0) {
          getProduct(activeTrip!.productCode).then((value) {
            DateTime endDate = DateTime.parse(value.endDate);
            String endDateCheck = DateFormat('yyyy-MM-dd').format(endDate);
            if (checkEndedProduct(endDateCheck)) {
              endTrip(widget.userId, widget.csrfToken);
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Viaje Terminado'),
                    content: const Text(
                        'Gracias por viajar con nosotros, esperamos que haya disfrutado tu viaje.\n\nRecuerda mirar la sección de Productos para ver los nuevos viajes disponibles'),
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
        }
      });
    });
    getPendingTrip(widget.userId).then((value) {
      if (value.code != 0) {
        getProduct(value.productCode).then((value) {
          DateTime startDate = DateTime.parse(value.startDate);
          if (checkTripStart(startDate)) {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: const Text('Confirmación de Viaje'),
                  content: const Text(
                      'Requerimos que confirmes tu asistencia al viaje para poder continuar'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () {
                        cancelTrip(widget.userId, widget.csrfToken);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Viaje Cancelado Correctamente')),
                        );
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('Confirmar'),
                      onPressed: () {
                        confirmTrip(widget.userId, widget.csrfToken);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Viaje Confirmado Correctamente')),
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          }
        });
      }
    });
  }

  bool checkEndedProduct(String endDate) {
    final now = DateTime.now();
    String nowDate = DateFormat('yyyy-MM-dd').format(now);
    if (nowDate == endDate) {
      return true;
    } else {
      return false;
    }
  }

  bool checkTripStart(DateTime startDate) {
    final now = DateTime.now();
    final difference = now.difference(startDate);
    const threeDays = Duration(days: 3);
    return difference <= threeDays;
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
              const Text('HISTORIAL DE VIAJES',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  onPressed: activeTrip?.state == "IN PROGRESS"
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ActiveTripScreen(
                                      userId: widget.userId,
                                      csrfToken: widget.csrfToken,
                                      productId: activeTrip!.productCode,
                                    )),
                          );
                        }
                      : null,
                  child: const Text('Viaje Activo'),
                ),
              ]),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: endedTrips.length,
                itemBuilder: (context, index) {
                  final product = endedTrips[index];
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TripItineraryScreen(
                                        userId: widget.userId,
                                        csrfToken: widget.csrfToken,
                                        productId: product.code,
                                        productName: product.name,
                                      )),
                            );
                          },
                          title: Text(product.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pais Destino: ${product.country}'),
                              Text('Precio: \$${product.price}'),
                              Text('Fecha de inicio: ${product.startDate}'),
                              Text('Fecha de fin: ${product.endDate}'),
                            ],
                          ),
                          leading: const Icon(Icons.trip_origin),
                          trailing: const Icon(Icons.arrow_forward),
                        ),
                      ),
                      const Divider(
                        thickness: 2.0,
                        indent: 16.0,
                        endIndent: 16.0,
                      ),
                    ],
                  );
                },
              ),
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
