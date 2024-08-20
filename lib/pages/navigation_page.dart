import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:driveby/pages/driver_search_page.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  double _fareEstimate = 0.0;
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, LatLng?>;
    _pickupLocation = args['pickup'];
    _destinationLocation = args['destination'];
  
    _calculateFare('Standard Ride'); // Pass the ride type argument
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Navigation"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pickup and Destination Info
            _buildLocationInfo('Pickup Location', _pickupLocation),
            SizedBox(height: 16.0),
            _buildLocationInfo('Destination Location', _destinationLocation),
            SizedBox(height: 32.0),

            // Fare Estimation
            Text(
              'Estimated Fare: €${_fareEstimate.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.0),

            // Ride Options
            _buildFareOption('Standard Ride', 4, _fareEstimate),
            _buildFareOption('Taxi', 4, _fareEstimate * 1.2),
            _buildFareOption('Taxi XL', 7, _fareEstimate * 1.5),
            SizedBox(height: 32.0),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => DriverSearchPage()),
  );
},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text('Search for a Driver'),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle scheduling
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    minimumSize: Size(100, 50),
                  ),
                  child: Text('Schedule'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(String title, LatLng? location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Text(
          location != null ? 'Lat: ${location.latitude}, Lng: ${location.longitude}' : 'Location not set',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  void _calculateFare(String rideType) {
  if (_pickupLocation != null && _destinationLocation != null) {
    final distance = Distance();
    final double km = distance.as(
      LengthUnit.Kilometer,
      _pickupLocation!,
      _destinationLocation!,
    );

    double baseFare;
    double ratePerKm;

    switch (rideType) {
      case 'Standard Ride':
        baseFare = 3.0;
        ratePerKm = 1.5;
        break;
      case 'Taxi':
        baseFare = 4.0;
        ratePerKm = 1.8;
        break;
      case 'Taxi XL':
        baseFare = 5.0;
        ratePerKm = 2.0;
        break;
      default:
        baseFare = 0.0;
        ratePerKm = 0.0;
    }

    setState(() {
      _fareEstimate = baseFare + (km * ratePerKm);
    });
  } else {
    setState(() {
      _fareEstimate = 0.0;
    });
  }
}


  Widget _buildFareOption(String title, int capacity, double price) {
    return ListTile(
      leading: Icon(Icons.directions_car, color: Colors.red),
      title: Text(title),
      subtitle: Text('Best price for up to $capacity people'),
      trailing: Text('€${price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green)),
      onTap: () {
        // Handle fare option selection
      },
    );
  }
}
