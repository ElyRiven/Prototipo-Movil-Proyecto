import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;
  final int userId;
  final String csrfToken;
  final double placeLatitude;
  final double placeLongitude;
  const CameraScreen({
    super.key,
    required this.userId,
    required this.csrfToken,
    required this.cameraController,
    required this.placeLatitude,
    required this.placeLongitude,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

Future<void> checkLocation(CameraController cameraController,
    double placeLatitude, double placeLongitude) async {
  try {
    await cameraController.takePicture().then((XFile? file) {
      if (file != null) print("Foto tomada: ${file.path}");
    });

    // Acceder a los datos de ubicación
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final deviceLatitude = position.latitude;
    final deviceLongitude = position.longitude;

    final distanceBetweenPlaces = await Geolocator.distanceBetween(
            deviceLatitude, deviceLongitude, 37.42, -122) /
        1000;
    final maxDistance = 100;
    print('Distancia entre lugares: $distanceBetweenPlaces');
    if (distanceBetweenPlaces <= maxDistance) {
      print('¡Felicidades! Has ganado el beneficio');
    } else {
      print('¡Lo sentimos! No estás cerca del lugar');
    }
  } catch (e) {
    print('Error al tomar la fotografía: $e');
  }
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(widget.cameraController),
          ),
          ElevatedButton(
            onPressed: () {
              checkLocation(widget.cameraController, widget.placeLatitude,
                  widget.placeLongitude);
            },
            child: const Text('Tomar foto'),
          ),
        ],
      ),
    );
  }
}
