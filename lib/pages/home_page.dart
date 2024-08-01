import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi!',
                    style: TextStyle(
                      fontSize: 14.0, // Smaller "Hi!" text
                    ),
                  ),
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0, // Bigger "Welcome back!" text
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.yellow[700],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enjoy your next trip',
                    style: TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/book');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black, backgroundColor: Colors.white,
                    ),
                    child: Text('Book now'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildOptionButton(
                    context,
                    icon: Icons.local_taxi,
                    label: 'Taxi & Ride',
                    route: '/book',
                  ),
                ),
                SizedBox(width: 16), // Add space between the buttons
                Expanded(
                  child: _buildOptionButton(
                    context,
                    icon: Icons.two_wheeler,
                    label: '2 Wheels',
                    route: '/book',
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildSearchBar(),
            SizedBox(height: 20),
            _buildShortcutButton('Home', 'Set home address'),
            _buildShortcutButton('Work', 'Set work address'),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, {required IconData icon, required String label, required String route}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.black),
            SizedBox(height: 10),
            Text(label, style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Where are you going?',
        prefixIcon: Icon(Icons.circle, color: Colors.yellow),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildShortcutButton(String title, String subtitle) {
    return ListTile(
      leading: Icon(Icons.home, color: Colors.black),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        // Handle shortcut tap
      },
    );
  }
}
