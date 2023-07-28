import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> saveUser(
    int userCode,
    String firstName,
    String lastName,
    String mail,
    int idNumber,
    int phone,
    String password,
    int role,
    String csrfToken) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/user/');

  final requestBody = {
    "use_code": userCode,
    "use_firstname": firstName,
    "use_lastname": lastName,
    "use_email": mail,
    "use_idnumber": "$idNumber",
    "use_phonenumber": "$phone",
    "use_password": password,
    "rol_code": role
  };

  try {
    final response = await http.put(
      url,
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'csrftoken=$csrfToken',
        'x-csrftoken': csrfToken,
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error al actualizar datos: $error');
  }
}

Future<void> saveFirstLogin(
    int userCode, String firstLogin, String csrfToken) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/saveFirstLogin/');

  final requestBody = {
    "use_code": userCode,
    "use_firstlogin": firstLogin,
  };

  try {
    final response = await http.put(
      url,
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'csrftoken=$csrfToken',
        'x-csrftoken': csrfToken,
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error al guardar fecha: $error');
  }
}

Future<void> resetBenefits(int userCode, String csrfToken) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/resetBenefits/');

  final requestBody = {
    "use_code": userCode,
  };

  try {
    final response = await http.put(
      url,
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'csrftoken=$csrfToken',
        'x-csrftoken': csrfToken,
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error al reiniciar los beneficios: $error');
  }
}

Future<void> resetPoints(int userCode, String csrfToken) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/restartPoints/');

  final requestBody = {
    "use_code": userCode,
  };

  try {
    final response = await http.put(
      url,
      body: jsonEncode(requestBody),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': 'csrftoken=$csrfToken',
        'x-csrftoken': csrfToken,
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error al reiniciar los puntos: $error');
  }
}
