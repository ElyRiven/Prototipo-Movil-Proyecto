import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CameraScreen extends StatefulWidget {
  final CameraController cameraController;
  final int userId;
  final String csrfToken;
  final double placeLatitude;
  final double placeLongitude;
  const CameraScreen(
      {super.key,
      required this.userId,
      required this.csrfToken,
      required this.cameraController,
      required this.placeLatitude,
      required this.placeLongitude});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  Future<bool> checkLocation(
      cameraController, double placeLatitude, double placeLongitude) async {
    try {
      await cameraController.takePicture();
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

      // Utilizar la localizacion del dispositivo como parámetros de inicio
      final distanceBetweenPlaces = Geolocator.distanceBetween(
              placeLatitude, placeLongitude, placeLatitude, placeLongitude) /
          1000;
      const maxDistance = 100;
      //print('Distancia entre lugares: $distanceBetweenPlaces');
      if (distanceBetweenPlaces <= maxDistance) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(widget.cameraController),
          ),
          ElevatedButton(
            onPressed: () {
              checkLocation(widget.cameraController, widget.placeLatitude,
                      widget.placeLongitude)
                  .then((value) {
                if (value == true) {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('¡Felicidades!'),
                        content: const Text('Has completado el logro'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Aceptar'),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context, true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: const Text('Lo sentimos...'),
                        content: const Text(
                            'No estás cerca del lugar. Inténtalo nuevamente'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Aceptar'),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context, false);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            },
            child: const Text('Tomar foto'),
          ),
        ],
      ),
    );
  }
}
