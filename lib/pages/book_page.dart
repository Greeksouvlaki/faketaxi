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
  List<LatLng> _routePoints = [];
  TextEditingController _startController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearchingStart = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Ride'),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Container for the search boxes
                    Container(
                      padding: const EdgeInsets.all(4.0), // Reduced padding
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 211, 211, 211).withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Starting Location
                          Row(
                            children: [
                              const SizedBox(width: 15),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: TextField(
                                  controller: _startController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter starting location',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    _onSearch(value, true);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: Divider(
                              height: 0.2,
                              color: Color.fromARGB(255, 228, 228, 228),
                              thickness: 1.0,
                            ), // Reduced height
                          ),
                          // Destination Location
                          Row(
                            children: [
                              const SizedBox(width: 15),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: TextField(
                                  controller: _destinationController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter destination',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    _onSearch(value, false);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_searchResults.isNotEmpty)
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final result = _searchResults[index];
                            return ListTile(
                              title: Text(result['place_name']),
                              onTap: () {
                                _onLocationSelected(result['lat'], result['lon']);
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
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
                      urlTemplate: "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
                      additionalOptions: {
                        'accessToken': 'pk.eyJ1IjoiZ3JlZWtzb3V2bGFraSIsImEiOiJjbHlveGFkdzEwbGlsMmtzNTRybnlsZ2FhIn0.VfKArqX5m9V3Flffhb93oQ',
                        'id': 'mapbox/streets-v11',
                      },
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
                            color: Colors.black,
                            strokeWidth: 4.0,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20, // Positioning the button at the bottom
            left: 16,
            right: 16,
            child: ElevatedButton(
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
                padding: EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                minimumSize: Size(double.infinity, 75), // Make it full width
              ),
              child: Text('Request a Ride', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(LatLng latLng) async {
    final address = await _getAddressFromLatLng(latLng);
    setState(() {
      if (_pickupLocation == null) {
        _pickupLocation = latLng;
        _startController.text = address; // Set actual address
      } else if (_destinationLocation == null) {
        _destinationLocation = latLng;
        _destinationController.text = address; // Set actual address
        _fetchRoute();
      } else {
        _pickupLocation = latLng;
        _destinationLocation = null;
        _routePoints.clear();
        _destinationController.clear();
      }
    });
  }

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    final url = Uri.parse(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/${latLng.longitude},${latLng.latitude}.json?access_token=pk.eyJ1IjoiZ3JlZWtzb3V2bGFraSIsImEiOiJjbHlveGFkdzEwbGlsMmtzNTRybnlsZ2FhIn0.VfKArqX5m9V3Flffhb93oQ'
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['features'].isNotEmpty) {
        return data['features'][0]['place_name']; // Get the formatted address
      } else {
        return 'Unknown location';
      }
    } else {
      throw Exception('Failed to load address');
    }
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];
    if (_pickupLocation != null) {
      markers.add(
        Marker(
          point: _pickupLocation!,
          width: 80.0,
          height: 80.0,
          child: const Icon(Icons.location_on, color: Colors.black), // Changed color to black
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
          _routePoints = geometry.map((point) => LatLng(point[1], point[0])).toList();
        });
      } else {
        print('Failed to fetch route');
      }
    }
  }

  void _onSearch(String query, bool isStartLocation) async {
    if (query.isNotEmpty) {
      final results = await searchLocation(query);
      setState(() {
        _searchResults = results;
        _isSearchingStart = isStartLocation;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  Future<List<Map<String, dynamic>>> searchLocation(String query) async {
    final url = Uri.parse('https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=pk.eyJ1IjoiZ3JlZWtzb3V2bGFraSIsImEiOiJjbHlveGFkdzEwbGlsMmtzNTRybnlsZ2FhIn0.VfKArqX5m9V3Flffhb93oQ');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['features'].map((item) => {
        'place_name': item['place_name'],
        'lat': item['geometry']['coordinates'][1].toString(),
        'lon': item['geometry']['coordinates'][0].toString(),
      }));
    } else {
      throw Exception('Failed to load location data');
    }
  }

  void _onLocationSelected(String lat, String lon) async {
    final latLng = LatLng(double.parse(lat), double.parse(lon));
    final address = await _getAddressFromLatLng(latLng);
    setState(() {
      if (_isSearchingStart) {
        _pickupLocation = latLng;
        _startController.text = address; // Set actual address
        _mapController.move(latLng, 15.0);
      } else {
        _destinationLocation = latLng;
        _destinationController.text = address; // Set actual address
        _mapController.move(latLng, 15.0);
        _fetchRoute();
      }
      _searchResults = [];
    });
  }
}