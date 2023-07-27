import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:prototipo_movil_proyecto/benefits/models/benefit_model.dart';
import 'package:prototipo_movil_proyecto/benefits/models/user_benefit_model.dart';
import 'package:prototipo_movil_proyecto/benefits/models/user_product_model.dart';
import 'package:prototipo_movil_proyecto/benefits/requests/benefits_requests.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/achievement_benefits_screen.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/progress_benefits_screen.dart';
import 'package:prototipo_movil_proyecto/products/screens/products_screen.dart';
import 'package:prototipo_movil_proyecto/trips/screens/trips_screen.dart';
import 'package:prototipo_movil_proyecto/users/models/user_model.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class BenefitScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  const BenefitScreen(
      {super.key, required this.userId, required this.csrfToken});

  @override
  State<BenefitScreen> createState() => _BenefitScreenState();
}

class _BenefitScreenState extends State<BenefitScreen> {
  int _selectedIndex = 3;
  int userPoints = 0;
  String userMail = '';
  List<User> users = [];
  List<Benefit> progressBenefits = [];
  List<Benefit> achievementBenefits = [];
  UserProduct? userProduct;
  List<UserBenefit> userBenefits = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = 3;
    getAllUsers().then((value) {
      setState(() {
        users = value;
        final currentUser =
            users.firstWhere((user) => user.code == widget.userId);
        userPoints = currentUser.points;
        userMail = currentUser.email.toLowerCase();

        //sendMail('benefit', userMail);
      });
    });
    getBenefits().then((value) {
      setState(() {
        progressBenefits = value
            .where((benefit) => benefit.type == 'PROGRESO Y DESARROLLO')
            .toList();
        achievementBenefits = value
            .where((benefit) => benefit.type == 'LOGROS Y PREMIOS')
            .toList();
      });
    });
    checkTrip(widget.userId).then((value) {
      setState(() {
        userProduct = value;
      });
    });
    getUserBenefits(widget.userId).then((value) {
      setState(() {
        userBenefits = value;
        for (var i = 0; i < 7; i++) {
          var userBenefit = userBenefits[i];
          if (i == 0) {
            if (userBenefit.state == 'COMPLETE') {
              continue;
            } else {
              if (userPoints >= 1500 && userPoints < 2000) {
                saveUserBenefit(
                    widget.userId, userBenefit.bencode, widget.csrfToken);
                saveBenefitLog(
                    widget.userId, userBenefit.bencode, widget.csrfToken);
                sendMail("Calcomanías para el Equipaje", userMail);
              }
            }
          } else if (i == 1) {
            if (userBenefit.state == 'COMPLETE') {
              continue;
            } else {
              if (userPoints >= 2000 && userPoints < 2500) {
                saveUserBenefit(
                    widget.userId, userBenefit.bencode, widget.csrfToken);
                saveBenefitLog(
                    widget.userId, userBenefit.bencode, widget.csrfToken);
                sendMail("Termo para Bebidas", userMail);
              }
            }
          } else if (i == 2) {
            if (userBenefit.state == 'COMPLETE') {
              continue;
            } else {
              if (userPoints >= 2500 && userPoints < 3000) {
                saveUserBenefit(
                    widget.userId, userBenefit.bencode, widget.csrfToken);
                saveBenefitLog(
                    widget.userId, userBenefit.bencode, widget.csrfToken);
                sendMail("Artículo de Playa", userMail);
              }
            }
          } else if (i == 3) {
            if (userBenefit.state == 'COMPLETE') {
              continue;
            } else {
              if (userPoints >= 3000) {
                saveUserBenefit(
                    widget.userId, userBenefit.bencode, widget.csrfToken);
                saveBenefitLog(
                    widget.userId, userBenefit.bencode, widget.csrfToken);
                sendMail("Maleta de Mano", userMail);
              }
            }
          }
        }
      });
    });
  }

  Future<void> sendMail(String benefit, String receiverMail) async {
    try {
      var userEmail = 'travelhunterpf@gmail.com';
      var message = Message();
      message.subject = 'Notificación de Beneficio Obtenido';
      message.text =
          '¡Felicidades! Has obtenido el beneficio de "$benefit"\n Guarda este correo para recibirlo en un futuro viaje.';
      message.from = Address(userEmail.toString());
      message.recipients.add(receiverMail.toString());
      var smtpServer = gmail(userEmail, 'yfclxbqnhjlfeylg');
      await send(message, smtpServer);
    } catch (e) {
      throw Exception('Error al enviar el correo: ${e.toString()}');
    }
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
              const Text('BENEFICIOS',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  onPressed: userProduct?.state == "IN PROGRESS"
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProgressBenefitScreen(
                                    userId: widget.userId,
                                    csrfToken: widget.csrfToken,
                                    userProduct: userProduct)),
                          );
                        }
                      : null,
                  child: const Text('Conociendo el Mundo'),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: userProduct?.state == "IN PROGRESS"
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AchievementBenefitScreen(
                                userId: widget.userId,
                                csrfToken: widget.csrfToken,
                                achievementBenefits: achievementBenefits,
                                userEmail: userMail,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: const Text('Baúl de Fotos'),
                )
              ]),
              const SizedBox(height: 10),
              const Text(
                'Tabla de Puntos',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.cyan,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                constraints: const BoxConstraints(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Usuario')),
                      DataColumn(label: Text('Puntos')),
                    ],
                    rows: users
                        .map((user) => DataRow(
                              cells: [
                                DataCell(
                                    Text('${user.firstName} ${user.lastName}')),
                                DataCell(Text('${user.points}')),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Tablas de Beneficios',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orange,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                constraints: const BoxConstraints(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Progreso y Desarrollo')),
                      DataColumn(label: Text('Puntos')),
                    ],
                    rows: progressBenefits
                        .map((benefit) => DataRow(
                              cells: [
                                DataCell(Text(benefit.name)),
                                DataCell(Text(
                                    '${1500 + (progressBenefits.indexOf(benefit) * 500)}')),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.orange,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                constraints: const BoxConstraints(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Logros y Premios')),
                      DataColumn(label: Text('Descuento')),
                    ],
                    rows: achievementBenefits
                        .map((benefit) => DataRow(
                              cells: [
                                DataCell(Text(benefit.name)),
                                const DataCell(Text(('10% de descuento'))),
                              ],
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 25),
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
