import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class BookPage extends StatefulWidget {
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final MapController _mapController = MapController();
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;
  double _distance = 0.0;
  List<LatLng> _routePoints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Ride'),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(37.9838, 23.7275), // Athens, Greece
                initialZoom: 13.0,
                onTap: (tapPosition, latLng) => _handleTap(latLng),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _buildMarkers(),
                ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        color: Colors.blue,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Distance: ${_distance.toStringAsFixed(2)} km',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: (_pickupLocation != null && _destinationLocation != null)
                      ? () {
                          Navigator.of(context).pushNamed(
                            '/navigation',
                            arguments: {
                              'pickup': _pickupLocation,
                              'destination': _destinationLocation,
                            },
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                  ),
                  child: Text('Request a Ride'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(LatLng latLng) {
    setState(() {
      if (_pickupLocation == null) {
        _pickupLocation = latLng;
      } else if (_destinationLocation == null) {
        _destinationLocation = latLng;
        _calculateDistance();
        _fetchRoute();
      } else {
        _pickupLocation = latLng;
        _destinationLocation = null;
        _distance = 0.0;
        _routePoints.clear();
      }
    });
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];
    if (_pickupLocation != null) {
      markers.add(
        Marker(
          point: _pickupLocation!,
          width: 80.0,
          height: 80.0,
          child: const Icon(Icons.location_on, color: Colors.green),
        ),
      );
    }
    if (_destinationLocation != null) {
      markers.add(
        Marker(
          point: _destinationLocation!,
          width: 80.0,
          height: 80.0,
          child: const Icon(Icons.location_on, color: Colors.red),
        ),
      );
    }
    return markers;
  }

  void _calculateDistance() {
    final Distance distance = Distance();
    setState(() {
      _distance = distance.as(
        LengthUnit.Kilometer,
        _pickupLocation!,
        _destinationLocation!,
      );
    });
  }

  Future<void> _fetchRoute() async {
    if (_pickupLocation != null && _destinationLocation != null) {
      final apiKey = '5b3ce3597851110001cf62483134a690bb164ad3b784a9c671de1eb8'; // Replace with your OpenRouteService API key
      final url = Uri.parse(
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${_pickupLocation!.longitude},${_pickupLocation!.latitude}&end=${_destinationLocation!.longitude},${_destinationLocation!.latitude}');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> geometry = data['features'][0]['geometry']['coordinates'];

        setState(() {
          _routePoints = geometry
              .map((point) => LatLng(point[1], point[0]))
              .toList();
        });
      } else {
        print('Failed to fetch route');
      }
    }
  }
}
