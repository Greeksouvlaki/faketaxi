import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverHomePage extends StatefulWidget {
  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool isAvailable = false;
  List<RideRequest> rideRequests = [];
  EarningsSummary? earningsSummary;
  CurrentRide? currentRide;

  @override
  void initState() {
    super.initState();
    _fetchDriverData();
  }

  Future<void> _fetchDriverData() async {
    try {
      // Fetch ride requests
      final rideRequestsResponse = await http.get(Uri.parse('http://your-api-url/driver/ride-requests'));
      if (rideRequestsResponse.statusCode == 200) {
        final List<dynamic> requestData = json.decode(rideRequestsResponse.body);
        setState(() {
          rideRequests = requestData.map((data) => RideRequest.fromJson(data)).toList();
        });
      }

      // Fetch earnings summary
      final earningsResponse = await http.get(Uri.parse('http://your-api-url/driver/earnings'));
      if (earningsResponse.statusCode == 200) {
        setState(() {
          earningsSummary = EarningsSummary.fromJson(json.decode(earningsResponse.body));
        });
      }

      // Fetch current ride details
      final currentRideResponse = await http.get(Uri.parse('http://your-api-url/driver/current-ride'));
      if (currentRideResponse.statusCode == 200) {
        setState(() {
          currentRide = CurrentRide.fromJson(json.decode(currentRideResponse.body));
        });
      }
    } catch (e) {
      print('Error fetching driver data: $e');
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        backgroundColor: Color.fromARGB(255, 235, 231, 13),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to profile/settings page
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAvailabilityToggle(),
            const SizedBox(height: 20),
            _buildRideRequestSection(),
            const SizedBox(height: 20),
            _buildEarningsSummary(),
            const SizedBox(height: 20),
            _buildCurrentRideDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityToggle() {
    return Card(
      color: isAvailable ? Colors.green[100] : Colors.red[100],
      child: ListTile(
        leading: Icon(
          isAvailable ? Icons.check_circle : Icons.remove_circle,
          color: isAvailable ? Colors.green : Colors.red,
          size: 40,
        ),
        title: Text(
          isAvailable ? 'You are Available' : 'You are Unavailable',
          style: TextStyle(
            color: isAvailable ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        trailing: Switch(
          value: isAvailable,
          onChanged: (value) async {
            setState(() {
              isAvailable = value;
            });
            // Optionally handle backend update for availability status
            await http.post(
              Uri.parse('http://your-api-url/driver/update-availability'),
              body: json.encode({'available': isAvailable}),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRideRequestSection() {
    if (rideRequests.isEmpty) {
      return Card(
        elevation: 4,
        child: ListTile(
          title: Text(
            'No Ride Requests',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ListTile(
            title: Text(
              'Incoming Ride Requests',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          ...rideRequests.map((request) => ListTile(
            leading: const Icon(Icons.directions_car, color: Color.fromARGB(255, 243, 229, 33)),
            title: Text('Pickup: ${request.pickupLocation}'),
            subtitle: Text('Destination: ${request.destination}'),
            trailing: ElevatedButton(
              onPressed: () {
                // Handle ride acceptance
              },
              child: const Text('Accept'),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildEarningsSummary() {
    if (earningsSummary == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Earnings Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text('Today: €${earningsSummary!.today}'),
            Text('This Week: €${earningsSummary!.thisWeek}'),
            Text('This Month: €${earningsSummary!.thisMonth}'),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentRideDetails() {
    if (currentRide == null) {
      return const SizedBox(); // No current ride
    }

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Ride',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text('Passenger: ${currentRide!.passenger}'),
            Text('Pickup: ${currentRide!.pickupLocation}'),
            Text('Destination: ${currentRide!.destination}'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Handle navigation or complete ride
              },
              child: const Text('Navigate to Pickup'),
            ),
          ],
        ),
      ),
    );
  }
}

// Example models for dynamic data
class RideRequest {
  final String pickupLocation;
  final String destination;

  RideRequest({required this.pickupLocation, required this.destination});

  factory RideRequest.fromJson(Map<String, dynamic> json) {
    return RideRequest(
      pickupLocation: json['pickupLocation'],
      destination: json['destination'],
    );
  }
}

class EarningsSummary {
  final double today;
  final double thisWeek;
  final double thisMonth;

  EarningsSummary({required this.today, required this.thisWeek, required this.thisMonth});

  factory EarningsSummary.fromJson(Map<String, dynamic> json) {
    return EarningsSummary(
      today: json['today'],
      thisWeek: json['thisWeek'],
      thisMonth: json['thisMonth'],
    );
  }
}

class CurrentRide {
  final String passenger;
  final String pickupLocation;
  final String destination;

  CurrentRide({required this.passenger, required this.pickupLocation, required this.destination});

  factory CurrentRide.fromJson(Map<String, dynamic> json) {
    return CurrentRide(
      passenger: json['passenger'],
      pickupLocation: json['pickupLocation'],
      destination: json['destination'],
    );
  }
}
