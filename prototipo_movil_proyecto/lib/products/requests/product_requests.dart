import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prototipo_movil_proyecto/products/models/product_model.dart';
import 'package:prototipo_movil_proyecto/users/models/user_model.dart';

Future<List<Product>> getSellingProducts() async {
  final url = Uri.parse('http://10.0.2.2:8000/api/getAllSellingProducts/');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;

      List<Product> productList = responseData.map((userData) {
        return Product(
          code: userData['pk'] as int,
          name: userData['fields']['pro_name'] as String,
          price: userData['fields']['pro_price'] as String,
          description: userData['fields']['pro_description'] as String,
          country: userData['fields']['pro_country'] as String,
          startDate: userData['fields']['pro_startdate'] as String,
          endDate: userData['fields']['pro_enddate'] as String,
          state: userData['fields']['pro_state'] as String,
        );
      }).toList();
      return productList;
    } else {
      return [];
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud');
  }
}

Future<User> getUser(int userId) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/user/?userId=$userId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)[0];
      final user = User(
        code: responseData['pk'] as int,
        firstName: responseData['fields']['use_firstname'] as String,
        lastName: responseData['fields']['use_lastname'] as String,
        email: responseData['fields']['use_email'] as String,
        idNumber: responseData['fields']['use_idnumber'] as String,
        phoneNumber: responseData['fields']['use_phonenumber'],
        password: responseData['fields']['use_password'],
        points: responseData['fields']['use_points'] as int,
        benSection: responseData['fields']['use_bensection'] as int,
        firstLogin:
            DateTime.parse(responseData['fields']['use_firstlogin'] as String),
        role: responseData['fields']['rol_code'] as int,
      );
      return user;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}

Future<void> saveAppointment(int userCode, int productCode, String csrfToken,
    String comment, String type) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/saveAppointment/');

  final requestBody = {
    "use_code": userCode,
    "pro_code": productCode,
    "app_type": type,
    "app_comment": comment.toUpperCase()
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
    throw Exception('Error al guardar la cita: $error');
  }
}
