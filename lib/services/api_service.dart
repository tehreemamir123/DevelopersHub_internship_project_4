import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String baseUrl = "https://jsonplaceholder.typicode.com";

  // Fetch list of users
  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/users"));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  // Fetch single user by ID
  static Future<User> fetchUserById(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$id"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception("Failed to load user details");
    }
  }
}
