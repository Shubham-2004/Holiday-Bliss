import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class Backend {
  static const String baseUrl = 'http://192.168.1.2/safe_bites';

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    var response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: {
        'signIn': 'true',
        'email': email,
        'password': password,
      },
    );

    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    var response = await http.post(
      Uri.parse('$baseUrl/signup.php'),
      body: {
        'signUp': 'true',
        'fName': firstName,
        'lName': lastName,
        'email': email,
        'password': password,
      },
    );

    return json.decode(response.body);
  }
}
