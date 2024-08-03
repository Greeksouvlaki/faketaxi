import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200, // Set the desired width
          height: 200, // Set the desired height
          child: Lottie.asset(
            'assets/animations/Animation - 1722510364618.json',
            repeat: true, // Do not loop the animation
            onLoaded: (composition) {
              // Calculate the total duration based on the number of times to repeat
              final totalDuration = composition.duration * 2; // Play 3 times
              Future.delayed(totalDuration, () {
                Navigator.of(context).pushReplacementNamed('/login');
              });
            },
          ),
        ),
      ),
    );
  }
}