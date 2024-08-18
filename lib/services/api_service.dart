import 'dart:convert';
import 'package:driveby/models/ride.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://172.18.28.244:3000/api';

  Future<http.Response> register(String username, String email, String password) async {
    final url = Uri.parse('$_baseUrl/users/register');
    try {
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
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/users/login');
    try {
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
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // New method to fetch ride history
  Future<List<Ride>> getRideHistory(int userId, String role) async {
    final url = Uri.parse('$_baseUrl/rides/history?userId=$userId&role=$role');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Ride.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load ride history');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}