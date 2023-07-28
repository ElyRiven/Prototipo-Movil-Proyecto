import 'dart:async';
import 'package:flutter/material.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/benefits_screen.dart';
import 'package:prototipo_movil_proyecto/products/models/place_model.dart';
import 'package:prototipo_movil_proyecto/products/screens/products_screen.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ItineraryPlaceScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  final Place? place;
  const ItineraryPlaceScreen(
      {super.key, required this.userId, required this.csrfToken, this.place});

  @override
  State<ItineraryPlaceScreen> createState() => _ItineraryPlaceScreenState();
}

class _ItineraryPlaceScreenState extends State<ItineraryPlaceScreen> {
  int _selectedIndex = 1;
  late double latPlace;
  late double longPlace;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    setState(() {
      latPlace = widget.place!.latitude;
      longPlace = widget.place!.longitude;
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
              const SizedBox(height: 20),
              Text(
                widget.place!.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 375,
                height: 450,
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(latPlace, longPlace), zoom: 17),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.cyan,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                constraints: const BoxConstraints(),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.description),
                      title: const Text("Descripción:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        widget.place?.description ?? "Cargando...",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.place),
                      title: const Text("Ciudad:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        widget.place?.city ?? "Cargando...",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.local_activity),
                      title: const Text("Actividades:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        widget.place?.activity ?? "Cargando...",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.date_range),
                      title: const Text("Fecha de Inicio:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        widget.place?.startDate ?? "Cargando...",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.date_range),
                      title: const Text("Fecha de Fin:",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        widget.place?.endDate ?? "Cargando...",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
