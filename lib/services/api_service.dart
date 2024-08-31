import 'dart:convert';
import 'package:driveby/models/ride.dart';
import 'package:driveby/models/users.dart';
import 'package:http/http.dart' as http;
import 'package:driveby/models/driver.dart';
import 'package:driveby/models/ride_request.dart';
import 'package:driveby/models/earnings_summary.dart';
import 'package:driveby/models/current_ride.dart';

class ApiService {
  static const String _baseUrl = 'https://6e5d-109-242-139-139.ngrok-free.app/api';

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
  Future<Map<String, dynamic>> login(String email, String password) async {
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
        // Convert the response body into a Map and return it
        final data = jsonDecode(response.body);
        return {
          'token': data['token'],
          'role': data['role'],
          'user_id': data['user_id'],
        };
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

// Driver Registration
Future<http.Response> registerDriver(String username, String email, String password, String vehicleType, String vehicleRegistration) async {
  final url = Uri.parse('$_baseUrl/drivers/register');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'vehicle_type': vehicleType,
        'vehicle_registration_number': vehicleRegistration,
      }),
    );

    // Log response status and body for debugging
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 201) {  // Make sure the status code for successful creation is 201 (Created)
      return response;
    } else {
      throw Exception('Failed to register driver');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}


// Driver Login
Future<http.Response> loginDriver(String email, String password) async {
  final url = Uri.parse('$_baseUrl/drivers/login');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to login driver');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

// Accept Ride Request
Future<http.Response> acceptRideRequest(int requestId, int driverId) async {
  final url = Uri.parse('$_baseUrl/drivers/ride-requests/$requestId/accept');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'driver_id': driverId}),
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to accept ride request');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

// Update Ride Status
Future<http.Response> updateRideStatus(int rideId, String status) async {
  final url = Uri.parse('$_baseUrl/drivers/rides/$rideId/status');
  try {
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': status}),
    );
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update ride status');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

// Fetch Driver Details:
Future<Driver> getDriver(int driverId) async {
  final url = Uri.parse('$_baseUrl/drivers/$driverId');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Driver.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load driver');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

// Create Ride Request:
Future<http.Response> createRideRequest(int passengerId, String pickupLocation, String destination, String vehicleType) async {
  final url = Uri.parse('$_baseUrl/rides/request');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'passenger_id': passengerId,
        'pickup_location': pickupLocation,
        'destination': destination,
        'vehicle_type': vehicleType,
      }),
    );
    return response;
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}

// Fetch Ride Requests
Future<List<RideRequest>> fetchRideRequests() async {
  final response = await http.get(Uri.parse('$_baseUrl/drivers/ride-requests'));
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => RideRequest.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load ride requests');
  }
}


// Fetch Earnings Summary
Future<EarningsSummary> fetchEarningsSummary(int driverId) async {
  final response = await http.get(Uri.parse('$_baseUrl/drivers/earnings?driverId=$driverId'));
  if (response.statusCode == 200) {
    return EarningsSummary.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load earnings summary');
  }
}


// Fetch Current Ride Details
Future<CurrentRide> fetchCurrentRide() async {
  final response = await http.get(Uri.parse('$_baseUrl/driver/current-ride'));
  if (response.statusCode == 200) {
    return CurrentRide.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load current ride');
  }
}

// Fetch user's payment methods
Future<List<dynamic>> getPaymentMethods(int userId) async {
  final response = await http.get(Uri.parse('$_baseUrl/api/users/$userId/payment-methods'));  // Update API endpoint here
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load payment methods');
  }
}

    // Add a new payment method
  Future<void> addPaymentMethod(int userId, int paymentMethodId, String? cardNumber, String? expiryDate, String? walletProvider) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/api/users/$userId/payment-methods'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'paymentMethodId': paymentMethodId,
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'walletProvider': walletProvider,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add payment method');
    }
  }


  // Update a payment method
  Future<void> updatePaymentMethod(int paymentMethodId, String paymentType, String? cardNumber, String? walletProvider, bool isDefault) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/api/payment-methods/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'payment_method_id': paymentMethodId,
        'payment_type': paymentType,
        'card_number': cardNumber,
        'wallet_provider': walletProvider,
        'is_default': isDefault,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update payment method');
    }
  }

  // Delete a payment method
  Future<void> deletePaymentMethod(int paymentMethodId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/api/payment-methods/delete'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'payment_method_id': paymentMethodId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete payment method');
    }
  }

}