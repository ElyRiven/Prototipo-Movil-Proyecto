import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/benefits_screen.dart';
import 'package:prototipo_movil_proyecto/products/models/product_model.dart';
import 'package:prototipo_movil_proyecto/products/requests/product_requests.dart';
import 'package:prototipo_movil_proyecto/trips/screens/trips_screen.dart';
import 'package:prototipo_movil_proyecto/users/models/user_model.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class ProductAppointmentScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  final int productId;
  final Product? product;
  const ProductAppointmentScreen(
      {super.key,
      required this.userId,
      required this.csrfToken,
      required this.productId,
      required this.product});

  @override
  State<ProductAppointmentScreen> createState() =>
      _ProductAppointmentScreenState();
}

class _ProductAppointmentScreenState extends State<ProductAppointmentScreen> {
  int _selectedIndex = 2;
  List<String> appointmentTypes = ["VIRTUAL", "PRESENCIAL"];
  String _selectedAppointmentType = "VIRTUAL";
  User? user;
  final TextEditingController _appointmentComment = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedIndex = 2;
    getUser(widget.userId).then((value) {
      setState(() {
        user = value;
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

  Future<bool> sendUserAppointmentMail(
      String appointmentType,
      String appointmentComment,
      String productName,
      String receiverMail) async {
    try {
      var userEmail = 'travelhunterpf@gmail.com';
      var message = Message();
      message.subject = 'Notificación de Cita';
      message.text =
          '¡Gracias por contactar con nosotros!\nHas solicitado una cita para el producto $productName.\nTipo de cita: $appointmentType\nComentarios: $appointmentComment\n\nEn breve nos pondremos en contacto contigo para confirmar la cita.\n\nAtentamente,\nTravel Hunter';
      message.from = Address(userEmail.toString());
      message.recipients.add(receiverMail.toString());
      var smtpServer = gmail(userEmail, 'yfclxbqnhjlfeylg');
      await send(message, smtpServer);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendCompanyAppointmentMail(
      String appointmentType,
      String appointmentComment,
      String productName,
      String userMail,
      String userFirstName,
      String userLastName) async {
    try {
      var userEmail = 'travelhunterpf@gmail.com';
      var message = Message();
      message.subject =
          'Notificación de Cita. Usuario $userFirstName $userLastName';
      message.text =
          'Cita Generada por el usuario $userFirstName $userLastName.\nEmail del Usuario: $userMail\nTipo de cita: $appointmentType\nComentarios: $appointmentComment\n\nAtentamente,\nTravel Hunter';
      message.from = Address(userEmail.toString());
      message.recipients.add(userEmail.toString());
      var smtpServer = gmail(userEmail, 'yfclxbqnhjlfeylg');
      await send(message, smtpServer);
      return true;
    } catch (e) {
      return false;
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
              Text(widget.product?.name ?? "Cargando...",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.cyan,
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  constraints: const BoxConstraints(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.description),
                        title: const Text("Descripcion:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          widget.product?.description ?? "Cargando...",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.place),
                        title: const Text("País Destino:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          widget.product?.country ?? "Cargando...",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.price_change),
                        title: const Text("Precio:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          "\$${widget.product?.price ?? "Cargando..."}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.date_range),
                        title: const Text("Fecha de Inicio:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          widget.product?.startDate ?? "Cargando...",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.date_range),
                        title: const Text("Fecha de Fin:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          widget.product?.endDate ?? "Cargando...",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              const Text('FORMULARIO DE CITA',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(
                width: 300.0,
                child: DropdownButtonFormField<String>(
                  value: _selectedAppointmentType,
                  items: appointmentTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAppointmentType = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Cita',
                  ),
                ),
              ),
              SizedBox(
                width: 300.0,
                child: TextField(
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  controller: _appointmentComment,
                  maxLength: 300,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Comentarios',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String appointmentType = _selectedAppointmentType;
                  String appointmentComment = _appointmentComment.text;
                  saveAppointment(widget.userId, widget.productId,
                      widget.csrfToken, appointmentComment, appointmentType);
                  try {
                    sendCompanyAppointmentMail(
                        appointmentType,
                        appointmentComment,
                        widget.product?.name ?? "",
                        user?.email ?? "",
                        user?.firstName ?? "",
                        user?.lastName ?? "");
                    sendUserAppointmentMail(
                        appointmentType,
                        appointmentComment,
                        widget.product?.name ?? "",
                        user?.email.toLowerCase() ?? "");
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Cita Generada Correctamente'),
                          content: Text(
                              '¡Gracias por contactar con nosotros!\nHas solicitado una cita para el producto ${widget.product?.name ?? ""}.\nTipo de cita: $appointmentType\nComentarios: $appointmentComment\n\nEn breve nos pondremos en contacto contigo para confirmar la cita.\n\nTravel Hunter'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('No se pudo generar la cita'),
                          content: const Text(
                              'Lo sentimos, has generado una cita recientemente para este u otro producto. Intenta de nuevo más tarde.\n\nTravel Hunter'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Enviar'),
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
