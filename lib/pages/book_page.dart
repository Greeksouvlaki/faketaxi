import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyBWISO8sQUmKlpgGxHa4G7WQTkEFfdUiVM";
final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class BookPage extends StatefulWidget {
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  TextEditingController _pickupController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  LatLng? _pickupLocation;
  LatLng? _destinationLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Ride'),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLocationSearchField(
              controller: _pickupController,
              label: 'Pickup Location',
              onSelected: (LatLng location) {
                setState(() {
                  _pickupLocation = location;
                });
              },
            ),
            SizedBox(height: 8.0),
            _buildLocationSearchField(
              controller: _destinationController,
              label: 'Destination',
              onSelected: (LatLng location) {
                setState(() {
                  _destinationLocation = location;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_pickupLocation != null && _destinationLocation != null) {
                  Navigator.of(context).pushNamed(
                    '/navigation',
                    arguments: {
                      'pickup': _pickupController.text,
                      'destination': _destinationController.text,
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.yellow,
              ),
              child: Text('Request a Ride'),
            ),
            SizedBox(height: 16.0),
            _buildPopularDestinations(),
            _buildHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSearchField({
    required TextEditingController controller,
    required String label,
    required Function(LatLng) onSelected,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      onTap: () async {
        Prediction? p = await PlacesAutocomplete.show(
          context: context,
          apiKey: kGoogleApiKey,
          mode: Mode.overlay,
          language: "en",
        );
        if (p != null) {
          PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);
          final lat = detail.result.geometry!.location.lat;
          final lng = detail.result.geometry!.location.lng;
          controller.text = p.description!;
          onSelected(LatLng(lat, lng));
        }
      },
    );
  }

  Widget _buildPopularDestinations() {
    final destinations = ['Airport', 'Central Station', 'City Center', 'Hotel', 'Restaurant'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Popular Destinations', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        Wrap(
          spacing: 8.0,
          children: destinations.map((destination) {
            return Chip(
              label: Text(destination),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onDeleted: () {},
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHistory() {
    final history = ['Home', 'Work', 'Gym', 'Supermarket'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Locations', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        Column(
          children: history.map((location) {
            return ListTile(
              title: Text(location),
              onTap: () {
                // Implement history selection
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
