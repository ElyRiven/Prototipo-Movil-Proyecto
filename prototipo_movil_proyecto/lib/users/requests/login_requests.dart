import 'dart:convert';

import 'package:http/http.dart' as http;

Future<int> login(usernameInp, passwordInp) async {
  final String username = usernameInp;
  final String password = passwordInp;

  final url = Uri.parse(
      'http://10.0.2.2:8000/api/verifyUser/?username=$username&password=$password');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final userId = responseData[0]["pk"];
      return userId;
    } else {
      return 0;
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud');
  }
}
