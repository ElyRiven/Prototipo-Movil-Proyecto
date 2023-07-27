import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prototipo_movil_proyecto/benefits/models/user_product_model.dart';
import 'package:prototipo_movil_proyecto/products/models/place_model.dart';
import 'package:prototipo_movil_proyecto/products/models/product_model.dart';

Future<List<Product>> getEndedTrips(int userId) async {
  final url =
      Uri.parse('http://10.0.2.2:8000/api/getEndedTrips/?userId=$userId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final List<Product> endedTrips = responseData.map((data) {
        return Product(
            code: data['pk'],
            name: data['fields']['pro_name'],
            price: data['fields']['pro_price'],
            description: data['fields']['pro_description'],
            country: data['fields']['pro_country'],
            startDate: data['fields']['pro_startdate'],
            endDate: data['fields']['pro_enddate'],
            state: data['fields']['pro_state']);
      }).toList();
      return endedTrips;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}

Future<List<Place>> getEndedTripItinerary(int productId) async {
  final url = Uri.parse(
      'http://10.0.2.2:8000/api/getEndedTripItinerary/?productId=$productId');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final List<Place> placesList = responseData.map((data) {
        return Place(
            code: data['pk'],
            name: data['fields']['pla_name'],
            description: data['fields']['pla_description'],
            activity: data['fields']['pla_activity'],
            city: data['fields']['pla_city'],
            startDate: data['fields']['pla_startdate'],
            endDate: data['fields']['pla_enddate'],
            latitude: double.parse(data['fields']['pla_latitude']),
            longitude: double.parse(data['fields']['pla_longitude']),
            proCode: data['fields']['pro_code']);
      }).toList();
      return placesList;
    } else {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error al realizar la solicitud: $error');
  }
}

Future<UserProduct> getPendingTrip(int userId) async {
  final url =
      Uri.parse('http://10.0.2.2:8000/api/getPendingTrip/?userId=$userId');

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

Future<void> endTrip(int userCode, String csrfToken) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/endTrip/');

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
    throw Exception('Error al enviar los puntos: $error');
  }
}

Future<void> confirmTrip(int userCode, String csrfToken) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/confirmTrip/');

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
    throw Exception('Error al enviar los puntos: $error');
  }
}

Future<void> cancelTrip(int userCode, String csrfToken) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/cancelTrip/');

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
    throw Exception('Error al enviar los puntos: $error');
  }
}
