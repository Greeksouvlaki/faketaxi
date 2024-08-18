import 'dart:convert';
import 'package:driveby/models/ride.dart';
import 'package:driveby/models/users.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://172.18.28.244:3000/api';

  // Register method
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

  // Login method
  Future<http.Response> login(String email, String password) async {
  final url = Uri.parse('$_baseUrl/users/login');
  try {
    // Debugging: Log the email and password
    print('Attempting login with email: "$email" and password: "$password"');

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

    // Log the response status and body
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

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


  // Method to fetch ride history
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

  // Method to get user profile data
  Future<User> getProfile(int userId) async {
    final url = Uri.parse('$_baseUrl/users/profile?userId=$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  // Method to update user profile data
  Future<void> updateProfile(User user) async {
  final url = Uri.parse('$_baseUrl/users/profile/update');
  try {
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    print('Request URL: $url');
    print('Request Body: ${jsonEncode(user.toJson())}');
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}


  // Method to change the user's password
  Future<void> changePassword(int userId, String oldPassword, String newPassword) async {
    final url = Uri.parse('$_baseUrl/users/change-password');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'oldPassword': oldPassword,
          'newPassword': newPassword,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
