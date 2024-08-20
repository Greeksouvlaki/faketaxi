import 'package:flutter/material.dart';

class DriverHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Home'),
      ),
      body: Center(
        child: Text('Welcome, Driver!'),
      ),
    );
  }
}
