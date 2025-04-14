import 'dart:convert';
import 'package:http/http.dart' as http;
import '../users/user_model.dart';

class ApiService {
  static Future<UserModel> fetchUser() async {
    final response = await http.get(Uri.parse('https://api.example.com/user'));

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }
}
