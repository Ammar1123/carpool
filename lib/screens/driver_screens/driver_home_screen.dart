import 'package:carpool/models/route.dart';
import 'package:carpool/models/client.dart';
import 'package:carpool/screens/driver_screens/add%20_ride_screen.dart';
import 'package:carpool/services/route_service.dart'; // Import the RouteService
import 'package:carpool/utils/constants.dart';
import 'package:carpool/widgets/ride_card_widget.dart';
import 'package:flutter/material.dart';

class DriverHomeScreen extends StatefulWidget {
  final Client currentUser;
  const DriverHomeScreen({super.key, required this.currentUser});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<DriverHomeScreen> {
  final RouteService routeService = RouteService(); // Initialize RouteService
  List<CarpoolRoute> availableRoutes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back',
              style: TextStyle(fontSize: 13),
            ),
            Text(
              widget.currentUser.name,
              style: const TextStyle(fontSize: 22),
            ),
          ],
        ),
        centerTitle: false,
        actions: <Widget>[
          TextButton(
            child: const Text('Add Ride',
                style: TextStyle(fontSize: 18, color: Colors.black)),
            onPressed: () {
              // Navigate to the 'Add Ride' page
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddRideScreen(
                        driver: widget
                            .currentUser)), // Assuming AddRideScreen is the page to add rides
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<CarpoolRoute>>(
        stream: routeService.getAllRoutes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong: ${snapshot.error}');
          }

          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // Update available routes
          availableRoutes = snapshot.data!
              .where((route) => !myGlobalCartList.contains(route))
              .toList();

          // Filter routes starting and ending at AinShams
          var startingRoutes = availableRoutes
              .where((route) => route.startLocation == 'AinShams')
              .toList();
          var endingRoutes = availableRoutes
              .where((route) => route.endLocation == 'AinShams')
              .toList();

          List<Widget> items = [];

          // Add header and routes for starting location
          items.add(const Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text('Routes Starting from AinShams:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ));
          if (startingRoutes.isNotEmpty) {
            items.addAll(startingRoutes
                .map((route) => buildRouteTile(route, context))
                .toList());
          } else {
            items.add(const Padding(
              padding: EdgeInsets.all(10),
              child: Text('No routes available starting from AinShams'),
            ));
          }

          // Add header and routes for ending location
          items.add(const Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text('Routes Ending at AinShams:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ));
          if (endingRoutes.isNotEmpty) {
            items.addAll(endingRoutes
                .map((route) => buildRouteTile(route, context))
                .toList());
          } else {
            items.add(const Padding(
              padding: EdgeInsets.all(10),
              child: Text('No routes available ending at AinShams'),
            ));
          }

          return ListView(children: items);
        },
      ),
    );
  }

  Widget buildRouteTile(CarpoolRoute route, BuildContext context) {
    return RideCard(
      route: route,
      currentUser: widget.currentUser,
      showReservationButton: false,
    );
  }
}
