import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> login(usernameInp, passwordInp) async {
  final String username = usernameInp;
  final String password = passwordInp;

  final url = Uri.parse(
      'http://10.0.2.2:8000/api/verifyUser/?username=$username&password=$password');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final userId = responseData[0]["pk"];
      final cookieHeader = response.headers["set-cookie"];
      final match = RegExp(r"csrftoken=(.*?);").firstMatch(cookieHeader!);
      final csrfToken = (match?.group(1) ?? "");
      return {"userId": userId, "csrfToken": csrfToken};
    } else {
      return {};
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud');
  }
}
