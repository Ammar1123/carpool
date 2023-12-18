import 'package:carpool/models/client.dart';
import 'package:carpool/pages/login_screen.dart';
import 'package:carpool/sql_lite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

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
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              )); // Redirect to login screen
            },
          )
        ],
      ),
      body: isLoading || currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildHeader(),
                  const SizedBox(height: 10),
                  _buildProfileInfo('Username', currentUser!.name),
                  _buildProfileInfo('Email', currentUser!.email),
                  _buildProfileInfo('Balance', currentUser!.balance.toString()),
                  // Add more profile fields here
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: CircleAvatar(
        radius: 70,
        backgroundColor: Colors.blue,
        backgroundImage: NetworkImage(currentUser!.clientImageUrl),
      ),
    );
  }

  Widget _buildProfileInfo(String title, String value) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
          color: Colors.transparent),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
        trailing: const Icon(
          Icons.edit,
          color: Colors.white,
        ), // Optional: if you want an edit icon
      ),
    );
  }
}
