import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'pages/login_page.dart';
import 'pages/registration_page.dart';
import 'pages/home_page.dart';
import 'pages/book_page.dart';
import 'pages/navigation_page.dart';
import 'pages/profile_page.dart';
import 'pages/driver_home_page.dart';

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
           bodyLarge: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
          bodyMedium: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
        '/book': (context) => BookPage(),
        '/navigation': (context) => NavigationPage(),
        '/profile': (context) => ProfilePage(),
        '/driverHome': (context) => DriverHomePage(),
      },
    );
  }
}
