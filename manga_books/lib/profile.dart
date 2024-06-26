import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For shared preferences

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150'), // Replace with actual profile image URL
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'John Doe', // Replace with actual user name
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: Text(
                'john.doe@example.com', // Replace with actual user email
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            SizedBox(height: 30),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings screen or handle settings logic
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                _logout(context); // Call the logout function
              },
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle logout
  Future<void> _logout(BuildContext context) async {
    // Clear user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all shared preferences, you can also clear specific keys if needed

    // Navigate to login screen
    // Assuming LoginScreen() is your login screen widget
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}

// Dummy LoginScreen class for navigation purpose, replace with your actual login screen class
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Text('This is the login screen'), // Replace with actual login UI
      ),
    );
  }
}
