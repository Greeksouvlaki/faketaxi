import 'package:flutter/material.dart';

class BookPage extends StatelessWidget {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Request a Ride',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildTextField('Pickup Location'),
            SizedBox(height: 10),
            _buildTextField('Destination'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle ride request
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.yellow,
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              child: Text('Request Ride'),
            ),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Text(
              'Available Rides',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with actual ride count
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Ride ${index + 1}'),
                    subtitle: Text('Details of the ride'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Handle ride selection
                      },
                      child: Text('Select'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}
