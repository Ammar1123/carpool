import 'package:carpool/models/client.dart';
import 'package:carpool/screens/client_screens/home_screen.dart';
import 'package:carpool/screens/client_screens/order_history_screen.dart';
import 'package:carpool/screens/client_screens/profile_screen.dart';
import 'package:carpool/services/auth_service.dart';
import 'package:carpool/utils/database_helper.dart';
import 'package:flutter/material.dart';

class MainClientApp extends StatefulWidget {
  const MainClientApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainClientApp> {
  Client? currentUser;
  int currentIndex = 0;

  @override
  void initState() {
    _loadCurrentUser();
    super.initState();
  }

  _loadCurrentUser() async {
    currentUser = await AuthService().getClient();
    await DatabaseHelper.instance.insertClient(currentUser!);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      if (currentUser != null)
        HomeScreen(currentUser: currentUser!)
      else
        const CircularProgressIndicator(), // Show loading indicator if currentUser is null
      const OrderHistoryScreen(),
      if (currentUser != null)
        ProfileScreen(userId: currentUser!.id)
      else
        const CircularProgressIndicator(), // Show loading indicator if currentUser is null
    ];

    return Scaffold(
      body: pages[
          currentIndex], // Display the page that corresponds to the current index
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Colors.yellow, // Yellow background for the bottom navigation bar
        unselectedItemColor: Colors.black, // Black color for unselected icons
        selectedItemColor: Colors.black, // Black color for selected icons
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Homepage'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
