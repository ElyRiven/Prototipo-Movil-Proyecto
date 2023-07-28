import 'package:flutter/material.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/benefits_screen.dart';
import 'package:prototipo_movil_proyecto/products/models/product_model.dart';
import 'package:prototipo_movil_proyecto/products/requests/product_requests.dart';
import 'package:prototipo_movil_proyecto/products/screens/product_itinerary_screen.dart';
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
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 2;
    getSellingProducts().then((value) {
      setState(() {
        products = value;
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
          const SizedBox(height: 20),
          const Text(
            'PRODUCTOS DISPONIBLES',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
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
                              builder: (context) => ProductItineraryScreen(
                                userId: widget.userId,
                                csrfToken: widget.csrfToken,
                                productId: product.code,
                                product: product,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('País Destino: ${product.country}'),
                            Text('Precio: \$${product.price}'),
                            Text('Fecha de inicio: ${product.startDate}'),
                            Text('Fecha de fin: ${product.endDate}'),
                          ],
                        ),
                        leading: const Icon(Icons.event_available),
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
