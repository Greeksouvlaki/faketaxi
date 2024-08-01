import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://172.29.65.23:3000/api';

  Future<http.Response> register(String username, String email, String password) async {
    final url = Uri.parse('$_baseUrl/users/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/users/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    return response;
  }
}
