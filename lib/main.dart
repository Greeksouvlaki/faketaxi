import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'pages/login_page.dart';
import 'pages/registration_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart'; // Add this import
import 'pages/book_page.dart'; // Add this import

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi App',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          bodyText2: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(), // Add this route
        '/book': (context) => BookPage(), // Add this route
      },
    );
  }
}
