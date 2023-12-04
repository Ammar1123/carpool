import 'package:carpool/models/client.dart';
import 'package:carpool/utils/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  // Initialize with a User object
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Client? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClientData();
  }

  Future<void> _loadClientData() async {
    Client? client = await DatabaseHelper.instance.getClient(widget.userId);
    if (client != null) {
      setState(() {
        currentUser = client;
        isLoading = false;
      });
    } else {
      // Handle the scenario where client data is not found in local database
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Sign out
              Navigator.of(context)
                  .pushReplacementNamed('/login'); // Redirect to login screen
            },
          )
        ],
      ),
      body: isLoading || currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : _buildProfileView(),
    );
  }

  Widget _buildProfileView() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Profile Icon
            CircleAvatar(
              radius: 70,
              backgroundColor: Colors.blue,
              backgroundImage: NetworkImage(
                  currentUser!.clientImageUrl), // Load image from URL
            ),
            const SizedBox(height: 50),
            // Username`
            Text(
              'Username: ${currentUser!.name}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            // Email
            Text(
              'Email: ${currentUser!.email}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            Text('Balance: ${currentUser!.balance}',
                style: const TextStyle(fontSize: 18))
          ],
        ),
      ),
    );
  }
}
