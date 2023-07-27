import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:prototipo_movil_proyecto/benefits/models/benefit_model.dart';
import 'package:prototipo_movil_proyecto/benefits/models/user_benefit_model.dart';
import 'package:prototipo_movil_proyecto/benefits/requests/benefits_requests.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/camera_screen.dart';
import 'package:prototipo_movil_proyecto/products/screens/products_screen.dart';
import 'package:prototipo_movil_proyecto/trips/screens/trips_screen.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class AchievementBenefitScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  final List<Benefit> achievementBenefits;
  final String userEmail;
  const AchievementBenefitScreen(
      {super.key,
      required this.userId,
      required this.csrfToken,
      required this.achievementBenefits,
      required this.userEmail});

  @override
  State<AchievementBenefitScreen> createState() =>
      _AchievementBenefitScreenState();
}

class _AchievementBenefitScreenState extends State<AchievementBenefitScreen> {
  int _selectedIndex = 0;
  late CameraController _cameraController;
  List<bool> firstBenefit = [false, false, false, false, false, false, false];
  List<bool> secondBenefit = [false, false, false];
  List<bool> thirdBenefit = [false, false, false];
  List<UserBenefit> userBenefits = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 3;
    _initializeCamera();
    getUserBenefits(widget.userId).then((value) {
      setState(() {
        userBenefits = value;
        _checkBenefit(userBenefits);
      });
    });
  }

  Future<void> sendMail(String benefit, String receiverMail) async {
    try {
      var userEmail = 'travelhunterpf@gmail.com';
      var message = Message();
      message.subject = 'Notificación de Beneficio Obtenido';
      message.text =
          '¡Felicidades! Has obtenido el beneficio de "$benefit" y has obtenido un 10% de descuento en tu siguiente viaje.\n Guarda este correo para reclamar tu descuento en el siguiente viaje contratado.';
      message.from = Address(userEmail.toString());
      message.recipients.add(receiverMail.toString());
      var smtpServer = gmail(userEmail, 'yfclxbqnhjlfeylg');
      await send(message, smtpServer);
    } catch (e) {
      throw Exception('Error al enviar el correo: ${e.toString()}');
    }
  }

  void setStateBenefit1(int index) {
    setState(() {
      firstBenefit[index] = true;
    });
  }

  void setStateBenefit2(int index) {
    setState(() {
      secondBenefit[index] = true;
    });
  }

  void setStateBenefit3(int index) {
    setState(() {
      thirdBenefit[index] = true;
    });
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(camera, ResolutionPreset.medium);
    await _cameraController.initialize();
  }

  void _checkBenefit(List<UserBenefit> userBenefits) {
    if (userBenefits[4].state == "COMPLETE") {
      setState(() {
        firstBenefit = firstBenefit.map((e) => true).toList();
      });
    }
    if (userBenefits[5].state == "COMPLETE") {
      setState(() {
        secondBenefit = secondBenefit.map((e) => true).toList();
      });
    }
    if (userBenefits[6].state == "COMPLETE") {
      setState(() {
        thirdBenefit = thirdBenefit.map((e) => true).toList();
      });
    }
  }

  void _openCamera(
      double latitude, double longitude, String benefit, int index) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CameraScreen(
                userId: widget.userId,
                csrfToken: widget.csrfToken,
                cameraController: _cameraController,
                placeLatitude: latitude,
                placeLongitude: longitude)));
    getUserBenefits(widget.userId).then((value) {
      final userBenefitsList = value;
      if (result == true) {
        if (userBenefitsList[4].state == "INCOMPLETE") {
          if (benefit == "first") {
            setState(() {
              setStateBenefit1(index);
            });
            if (firstBenefit.every((element) => element == true)) {
              saveUserBenefit(widget.userId, 5, widget.csrfToken);
              saveBenefitLog(widget.userId, 5, widget.csrfToken);
              sendMail("Las 7 Maravillas del Mundo Moderno", widget.userEmail);
            }
          }
        }
        if (userBenefitsList[5].state == "INCOMPLETE") {
          if (benefit == "second") {
            setState(() {
              setStateBenefit2(index);
              if (secondBenefit.every((element) => element == true)) {
                saveUserBenefit(widget.userId, 6, widget.csrfToken);
                saveBenefitLog(widget.userId, 6, widget.csrfToken);
                sendMail("Viajero Americano", widget.userEmail);
              }
            });
          }
        }
        if (userBenefitsList[6].state == "INCOMPLETE") {
          if (benefit == "third") {
            setState(() {
              setStateBenefit3(index);
              if (thirdBenefit.every((element) => element == true)) {
                saveUserBenefit(widget.userId, 7, widget.csrfToken);
                saveBenefitLog(widget.userId, 7, widget.csrfToken);
                sendMail("Viajero Europeo", widget.userEmail);
              }
            });
          }
        }
      }
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
              const Text(
                "Toma una foto en los siguientes lugares para obtener el beneficio:",
                style: TextStyle(fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: firstBenefit[0] == false
                        ? () {
                            _openCamera(-13.1631, -72.5450, "first", 0);
                          }
                        : null,
                    child: const Text('Machu Picchu'),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: firstBenefit[1] == false
                        ? () {
                            _openCamera(20.6829, -88.5686, "first", 1);
                          }
                        : null,
                    child: const Text('Chichen Itzá'),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: firstBenefit[2] == false
                        ? () {
                            _openCamera(41.8902, 12.4922, "first", 2);
                          }
                        : null,
                    child: const Text('El Coliseo'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: firstBenefit[3] == false
                        ? () {
                            _openCamera(-22.9519, -43.2105, "first", 3);
                          }
                        : null,
                    child: const Text('El Cristo Redentor'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: firstBenefit[4] == false
                        ? () {
                            _openCamera(40.4319, 116.5704, "first", 4);
                          }
                        : null,
                    child: const Text('La Gran Muralla China'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: firstBenefit[5] == false
                        ? () {
                            _openCamera(30.3285, 35.4444, "first", 5);
                          }
                        : null,
                    child: const Text('Petra'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: firstBenefit[6] == false
                        ? () {
                            _openCamera(27.1751, 78.0421, "first", 6);
                          }
                        : null,
                    child: const Text('El Taj Mahal'),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Text(
                widget.achievementBenefits[1].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Toma una foto en las capitales de los siguientes paises Americanos para obtener el beneficio:",
                style: TextStyle(fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: secondBenefit[0] == false
                        ? () {
                            _openCamera(38.9072, -77.0369, "second", 0);
                          }
                        : null,
                    child: const Text('EEUU'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: secondBenefit[1] == false
                        ? () {
                            _openCamera(45.4215, -75.6982, "second", 1);
                          }
                        : null,
                    child: const Text('Canadá'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: secondBenefit[2] == false
                        ? () {
                            _openCamera(49.4326, -991332, "second", 2);
                          }
                        : null,
                    child: const Text('México'),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Text(
                widget.achievementBenefits[2].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Toma una foto en las capitales de los siguientes paises Europeos para obtener el beneficio:",
                style: TextStyle(fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: thirdBenefit[0] == false
                        ? () {
                            _openCamera(40.4168, -3.7038, "third", 0);
                          }
                        : null,
                    child: const Text('España'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: thirdBenefit[1] == false
                        ? () {
                            _openCamera(48.8566, 2.3522, "third", 1);
                          }
                        : null,
                    child: const Text('Francia'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: thirdBenefit[2] == false
                        ? () {
                            _openCamera(41.9028, 12.4964, "third", 2);
                          }
                        : null,
                    child: const Text('Italia'),
                  ),
                ],
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
