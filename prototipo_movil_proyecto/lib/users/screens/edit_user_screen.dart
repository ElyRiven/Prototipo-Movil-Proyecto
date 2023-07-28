import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'package:prototipo_movil_proyecto/benefits/screens/benefits_screen.dart';
import 'package:prototipo_movil_proyecto/products/screens/products_screen.dart';
import 'package:prototipo_movil_proyecto/trips/screens/trips_screen.dart';
import 'package:prototipo_movil_proyecto/users/models/user_model.dart';
import 'package:prototipo_movil_proyecto/users/requests/user_requests.dart';
import 'package:prototipo_movil_proyecto/users/screens/users_screen.dart';

class EditUserScreen extends StatefulWidget {
  final int userId;
  final String csrfToken;
  final User? user;
  const EditUserScreen(
      {super.key, required this.userId, required this.csrfToken, this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  int _selectedIndex = 0;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _checknewPasswordController =
      TextEditingController();
  bool checkPassword = false;
  bool checkNewPassword = false;
  String newFirstName = '';
  String newLastName = '';
  String newEmail = '';
  String newIdNumber = '';
  int newPhone = 0;
  String newPassword = '';
  int role = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController.text = widget.user!.firstName;
    _lastNameController.text = widget.user!.lastName;
    _emailController.text = widget.user!.email.toLowerCase();
    _idNumberController.text = widget.user!.idNumber;
    _phoneController.text = widget.user!.phoneNumber;
    role = widget.user!.role;
  }

  bool isValidEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
  }

  String encryptToMD5(String input) {
    var bytes = utf8.encode(input);
    var digest = md5.convert(bytes);
    var encryptedValue = digest.toString();
    return encryptedValue;
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('EDITAR USUARIO',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Container(
                  width: 350,
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.text_fields, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                labelText: "Nombre",
                                border: InputBorder.none,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(50)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresar un valor valido';
                                } else {
                                  newFirstName = value;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.text_fields, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                labelText: "Apellido",
                                border: InputBorder.none,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(50)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Ingresar un valor valido';
                                } else {
                                  newLastName = value;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.mail, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: "Correo Electronico",
                                border: InputBorder.none,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(50)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa un correo valido';
                                } else if (!isValidEmail(value)) {
                                  return 'Por favor ingresa un correo valido';
                                } else {
                                  newEmail = value;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.perm_identity, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _idNumberController,
                              decoration: const InputDecoration(
                                labelText: "Identificación",
                                border: InputBorder.none,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(10)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa una identificación válida';
                                } else {
                                  newIdNumber = value;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.phone_android, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                labelText: "Telefono",
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10)
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa un número válido';
                                } else {
                                  newPhone = int.parse(value);
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 350,
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.key, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              key: const Key('matchPassword'),
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: "Contraseña Actual",
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(32)
                              ],
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  String encryptedValue = encryptToMD5(value);
                                  if (encryptedValue != widget.user!.password) {
                                    return 'Contraseña Incorrecta';
                                  } else {
                                    checkPassword = true;
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.vpn_key, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _newPasswordController,
                              decoration: const InputDecoration(
                                labelText: "Nueva Contraseña",
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(32)
                              ],
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (checkPassword) {
                                    newPassword = value;
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.vpn_key, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              controller: _checknewPasswordController,
                              decoration: const InputDecoration(
                                labelText: "Repetir Nueva Contraseña",
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(32)
                              ],
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  if (checkPassword) {
                                    if (value != newPassword) {
                                      return 'La nueva contraseña no coincide';
                                    }
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        key: const Key('saveButton'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            saveUser(
                                    widget.userId,
                                    newFirstName,
                                    newLastName,
                                    newEmail,
                                    newIdNumber,
                                    newPhone,
                                    newPassword,
                                    widget.user!.role,
                                    widget.csrfToken)
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Datos guardados correctamente')),
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserScreen(
                                          userId: widget.userId,
                                          csrfToken: widget.csrfToken,
                                        )),
                              );
                            });
                          }
                        },
                        child: const Text('Guardar'))),
              ],
            ),
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
