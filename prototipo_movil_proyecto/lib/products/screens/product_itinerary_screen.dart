import 'package:flutter/material.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/benefits_screen.dart';
import 'package:prototipo_movil_proyecto/products/models/place_model.dart';
import 'package:prototipo_movil_proyecto/products/models/product_model.dart';
import 'package:prototipo_movil_proyecto/products/screens/itinerary_place_screen.dart';
import 'package:prototipo_movil_proyecto/products/screens/product_appointment_screen.dart';
import 'package:prototipo_movil_proyecto/trips/requests/trips_requests.dart';
import 'package:prototipo_movil_proyecto/trips/screens/trips_screen.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class ProductItineraryScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  final int productId;
  final Product? product;
  const ProductItineraryScreen(
      {super.key,
      required this.userId,
      required this.csrfToken,
      required this.productId,
      required this.product});

  @override
  State<ProductItineraryScreen> createState() => _ProductItineraryScreenState();
}

class _ProductItineraryScreenState extends State<ProductItineraryScreen> {
  int _selectedIndex = 2;
  List<Place> itinerary = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 2;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.product?.name ?? "Cargando...",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductAppointmentScreen(
                        userId: widget.userId,
                        csrfToken: widget.csrfToken,
                        productId: widget.productId,
                        product: widget.product,
                      ),
                    ),
                  );
                },
                child: const Text('Agendar Cita'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: itinerary.length,
              itemBuilder: (context, index) {
                final place = itinerary[index];
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
                              builder: (context) => ItineraryPlaceScreen(
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
                            Text('Descripcion: ${place.description}'),
                            Text('Ciudad: ${place.city}'),
                            Text('Actividades: ${place.activity}'),
                            Text('Fecha de inicio: ${place.startDate}'),
                            Text('Fecha de fin: ${place.endDate}'),
                          ],
                        ),
                        leading: const Icon(Icons.place),
                        trailing: const Icon(Icons.check),
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
