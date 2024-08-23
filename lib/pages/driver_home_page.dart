import 'package:flutter/material.dart';

class DriverHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Dashboard'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Driver Dashboard!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
