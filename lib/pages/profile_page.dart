import 'package:flutter/material.dart';
import 'package:driveby/services/api_service.dart';
import 'package:driveby/models/users.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<User> _profile;
  final int userId = 4; // Hardcoded userId

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _profile = ApiService().getProfile(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<User>(
        future: _profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            User user = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                SizedBox(height: 16),
                Text(
                  user.name ?? 'No name provided', // Handle null name
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  user.email ?? 'No email provided', // Handle null email
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit Profile'),
                  onTap: () {
                    // Handle profile editing
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Change Password'),
                  onTap: () {
                    // Handle password change
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    // Handle logout
                  },
                ),
              ],
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
