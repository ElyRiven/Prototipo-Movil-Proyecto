import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_movil_proyecto/benefits/models/benefit_model.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/camera_screen.dart';
import 'package:prototipo_movil_proyecto/products/screens/products_screen.dart';
import 'package:prototipo_movil_proyecto/trips/screens/trips_screen.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class AchievementBenefitScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  final List<Benefit> achievementBenefits;
  const AchievementBenefitScreen(
      {super.key,
      required this.userId,
      required this.csrfToken,
      required this.achievementBenefits});

  @override
  State<AchievementBenefitScreen> createState() =>
      _AchievementBenefitScreenState();
}

class _AchievementBenefitScreenState extends State<AchievementBenefitScreen> {
  int _selectedIndex = 0;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 3;
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  void _openCamera(double latitude, double longitude) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraScreen(
                userId: widget.userId,
                csrfToken: widget.csrfToken,
                cameraController: _cameraController,
                placeLatitude: latitude,
                placeLongitude: longitude)));
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
    } else if (index == 1) {
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
              const Text('BAÚL DE FOTOS', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Text(
                widget.achievementBenefits[0].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _openCamera(-13.1631, -72.5450);
                    },
                    child: const Text('Maccu Picchu'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Chichen Itzá'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('El Coliseo'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('El Cristo Redentor'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('La Gran Muralla China'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Petra'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('El Taj Mahal'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.achievementBenefits[1].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('EEUU'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Canadá'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('México'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Ecuador'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Argentina'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.achievementBenefits[2].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('España'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Francia'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Italia'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Inglaterra'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Portugal'),
                  ),
                ],
              )
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
