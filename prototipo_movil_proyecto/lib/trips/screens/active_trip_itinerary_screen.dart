import 'package:flutter/material.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/benefits_screen.dart';
import 'package:prototipo_movil_proyecto/products/models/place_model.dart';
import 'package:prototipo_movil_proyecto/products/screens/products_screen.dart';
import 'package:prototipo_movil_proyecto/trips/requests/trips_requests.dart';
import 'package:prototipo_movil_proyecto/trips/screens/active_trip_place_screen.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class ActiveTripItineraryScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  final int productId;
  const ActiveTripItineraryScreen(
      {super.key,
      required this.userId,
      required this.csrfToken,
      required this.productId});

  @override
  State<ActiveTripItineraryScreen> createState() =>
      _ActiveTripItineraryScreenState();
}

class _ActiveTripItineraryScreenState extends State<ActiveTripItineraryScreen> {
  int _selectedIndex = 1;
  List<Place> itinerary = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 1;
    getEndedTripItinerary(widget.productId).then((value) {
      setState(() {
        itinerary = value;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            "ITINERARIO",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            // Wrap the ListView.builder with Expanded
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: itinerary.length,
              itemBuilder: (context, index) {
                final place = itinerary[index];
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ActiveTripPlaceScreen(
                                userId: widget.userId,
                                csrfToken: widget.csrfToken,
                                place: place,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          place.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Descripción: ${place.description}'),
                            Text('Ciudad: ${place.city}'),
                            Text('Actividades: ${place.activity}'),
                            Text('Fecha de inicio: ${place.startDate}'),
                            Text('Fecha de fin: ${place.endDate}'),
                          ],
                        ),
                        leading: const Icon(Icons.place),
                        trailing: const Icon(Icons.arrow_forward),
                      ),
                    ),
                    const Divider(
                      thickness: 2.0, // Grosor de la línea del Divider
                      indent: 16.0, // Espacio a la izquierda del Divider
                      endIndent: 16.0, // Espacio a la derecha del Divider
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
