import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prototipo_movil_proyecto/benefits/models/benefit_model.dart';
import 'package:prototipo_movil_proyecto/benefits/models/question_model.dart';
import 'package:prototipo_movil_proyecto/benefits/models/user_benefit_model.dart';
import 'package:prototipo_movil_proyecto/benefits/models/user_product_model.dart';
import 'package:prototipo_movil_proyecto/products/models/product_model.dart';
import 'package:prototipo_movil_proyecto/users/models/user_model.dart';

Future<List<User>> getAllUsers() async {
  final url = Uri.parse('http://10.0.2.2:8000/api/getUsers/');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;

      List<User> userList = responseData.map((userData) {
        return User(
          code: userData['pk'] as int,
          firstName: userData['fields']['use_firstname'] as String,
          lastName: userData['fields']['use_lastname'] as String,
          email: userData['fields']['use_email'] as String,
          idNumber: userData['fields']['use_idnumber'] as String,
          phoneNumber: userData['fields']['use_phonenumber'] as String,
          password: userData['fields']['use_password'] as String,
          points: userData['fields']['use_points'] as int,
          benSection: userData['fields']['use_bensection'] as int,
          firstLogin:
              DateTime.parse(userData['fields']['use_firstlogin'] as String),
          role: userData['fields']['rol_code'] as int,
        );
      }).toList();
      userList.sort((a, b) => b.points.compareTo(a.points));
      return userList;
    } else {
      return [];
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud');
  }
}

Future<List<Benefit>> getBenefits() async {
  final url = Uri.parse('http://10.0.2.2:8000/api/getBenefits/');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final List<Benefit> benefits = responseData.map((data) {
        return Benefit(
          code: data['pk'] as int,
          name: data['fields']['ben_name'] as String,
          type: data['fields']['ben_type'] as String,
          description: data['fields']['ben_description'] as String,
        );
      }).toList();
      return benefits;
    } else {
      return [];
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud $error');
  }
}

Future<UserProduct> checkTrip(int userId) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/checkTrip/?userId=$userId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)[0];
      final userProduct = UserProduct(
        code: responseData['pk'] as int,
        state: responseData['fields']['usepro_state'] as String,
        userCode: responseData['fields']['use_code'] as int,
        productCode: responseData['fields']['pro_code'] as int,
      );
      return userProduct;
    } else {
      return UserProduct(
        code: 0,
        state: '',
        userCode: 0,
        productCode: 0,
      );
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}

Future<Product> getProduct(int productId) async {
  final url =
      Uri.parse('http://10.0.2.2:8000/api/getProduct/?productId=$productId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body)[0];
      final product = Product(
        code: responseData['pk'] as int,
        name: responseData['fields']['pro_name'] as String,
        price: responseData['fields']['pro_price'] as String,
        description: responseData['fields']['pro_description'] as String,
        country: responseData['fields']['pro_country'] as String,
        startDate: DateTime.parse(responseData['fields']['pro_startdate']),
        endDate: DateTime.parse(responseData['fields']['pro_enddate']),
        state: responseData['fields']['pro_state'] as String,
      );
      return product;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}

Future<List<Question>> getQuestions(String? country) async {
  final url =
      Uri.parse('http://10.0.2.2:8000/api/getQuestions/?country=$country');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final List<Question> questions = responseData.map((data) {
        return Question(
          code: data['pk'],
          description: data['fields']['que_description'],
          answer: data['fields']['que_answer'],
          couCode: data['fields']['cou_code'],
        );
      }).toList();
      return questions;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}

Future<void> sendPoints(int userCode, int points, String csrfToken) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/savePoints/');

  final requestBody = {
    'use_code': userCode,
    'use_points': points,
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
    throw Exception('Error al enviar los puntos: $error');
  }
}

Future<List<UserBenefit>> getUserBenefits(int userId) async {
  final url =
      Uri.parse('http://10.0.2.2:8000/api/getUserBenefits/?userId=$userId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final userBenefits = responseData.map((data) {
        return UserBenefit(
          code: data['pk'] as int,
          state: data['fields']['useben_state'] as String,
          usercode: data['fields']['use_code'] as int,
          bencode: data['fields']['ben_code'] as int,
        );
      }).toList();
      return userBenefits;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}

Future<void> saveUserBenefit(
    int userCode, int benefitCode, String csrfToken) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/completeBenefit/');

  final requestBody = {
    'use_code': userCode,
    'ben_code': benefitCode,
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
    throw Exception('Error al actualizar el beneficio: $error');
  }
}
