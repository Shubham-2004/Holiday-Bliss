import 'dart:convert';
import 'dart:io'; // For SocketException
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiEndpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent';
  static const String _apiKey =
      'AIzaSyCdBrP8GOaGjQgdX1RYOJnHo4xm8D61lmQ'; // Replace with your actual API key

  static Future<String?> generateContent(String inputText) async {
    final requestBody = json.encode({
      "contents": [
        {
          "parts": [
            {"text": inputText}
          ]
        }
      ]
    });

    try {
      final response = await http.post(
        Uri.parse('$_apiEndpoint?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      // Debugging: print the full response body to understand the structure
      print('Response status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Always return the response body
      return response.body;
    } catch (e) {
      print('Error during API request: $e');
      return 'Error occurred during the request'; // Graceful fallback on error
    }
  }
}
