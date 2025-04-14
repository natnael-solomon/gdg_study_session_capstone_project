import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  final String baseUrl = 'https://fakestoreapi.com'; // replace with your API URL

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/users'); // or /register

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "id": 54,
        'username': username,
        'email': email,
        'password': password,
        // Add fullName if backend accepts it
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final body = jsonDecode(response.body);
      return body; // Return the parsed response body to other parts of your code
    } else {
      final body = jsonDecode(response.body);
      final message = body['error'] ?? 'Signup failed';
      throw AuthException(message);
    }
  }
  Future<void> fvcd({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/users'); // or /register

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // success
      return;
    } else {
      final body = jsonDecode(response.body);
      final message = body['error'] ?? 'Signup failed';
      throw AuthException(message);
    }
  }
}
