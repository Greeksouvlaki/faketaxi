import 'package:flutter/material.dart';
import 'dart:async';

class DriverSearchPage extends StatefulWidget {
  @override
  _DriverSearchPageState createState() => _DriverSearchPageState();
}

class _DriverSearchPageState extends State<DriverSearchPage> {
  bool _driverFound = false;

  @override
  void initState() {
    super.initState();
    _searchForDriver();
  }

  void _searchForDriver() {
    // Simulate a delay while searching for a driver
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _driverFound = true;
      });
      // Navigate to a "Driver Found" or "No Driver Available" page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DriverFoundPage(driverFound: _driverFound)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Searching for a driver...'),
          ],
        ),
      ),
    );
  }
}

class DriverFoundPage extends StatelessWidget {
  final bool driverFound;

  DriverFoundPage({required this.driverFound});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Driver Search Result')),
      body: Center(
        child: Text(
          driverFound ? 'Driver Found!' : 'No Driver Available',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
