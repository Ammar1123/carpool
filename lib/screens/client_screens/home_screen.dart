import 'package:carpool/models/route.dart';
import 'package:carpool/models/client.dart';
import 'package:carpool/services/auth_service.dart';
import 'package:carpool/services/route_service.dart'; // Import the RouteService
import 'package:carpool/widgets/ride_card_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Client currentUser;
  const HomeScreen({super.key, required this.currentUser});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CarpoolRoute> availableRoutes = [];
  final RouteService routeService = RouteService(); // Initialize RouteService
  final AuthService authService = AuthService(); // Initialize AuthService
  bool isReservationFunctionEnabled = true;

  bool canReserveForTrip(DateTime tripTime) {
    DateTime now = DateTime.now();
    DateTime reservationDeadline;

    if (!isReservationFunctionEnabled) {
      return true; // Always allow if the function is disabled
    }
    if (tripTime.hour == 7 && tripTime.minute == 30) {
      // For 7:30 AM trip, deadline is 10:00 PM the previous day
      reservationDeadline =
          DateTime(tripTime.year, tripTime.month, tripTime.day - 1, 22);
    } else if (tripTime.hour == 17 && tripTime.minute == 30) {
      // For 5:30 PM trip, deadline is 1:00 PM the same day
      reservationDeadline =
          DateTime(tripTime.year, tripTime.month, tripTime.day, 13);
    } else {
      return false; // If the trip time doesn't match the predefined trips
    }
    return now.isBefore(reservationDeadline);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Client?>(
      future: authService.getClient(),
      builder: (context, clientSnapshot) {
        if (clientSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (clientSnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('An error occurred: ${clientSnapshot.error}'),
            ),
          );
        } else if (clientSnapshot.hasData && clientSnapshot.data != null) {
          Client? client = clientSnapshot.data;
          return StreamBuilder<List<CarpoolRoute>>(
            stream: routeService.getAllRoutes(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong: ${snapshot.error}');
              }

              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              List<CarpoolRoute> availableRoutes = snapshot.data ?? [];
              return Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 60,
                    title: Text('Welcome back ${widget.currentUser.name}'),
                    centerTitle: true,
                  ),
                  body: _buildRoutesList(availableRoutes, client));
            },
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text('No user data available'),
            ),
          );
        }
      },
    );
  }

  Widget _buildRoutesList(List<CarpoolRoute> routes, Client? client) {
    List<Widget> routeWidgets = [];

    // Adding title and routes for trips starting from AinShams
    List<CarpoolRoute> routesFromAinShams =
        routes.where((route) => route.startLocation == 'AinShams').toList();
    if (routesFromAinShams.isNotEmpty) {
      routeWidgets.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            const Text('Trips from AinShams',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Switch(
              value: isReservationFunctionEnabled,
              onChanged: (value) {
                setState(() {
                  isReservationFunctionEnabled = value;
                });
              },
            ),
          ],
        ),
      ));
      routeWidgets.addAll(routesFromAinShams.map((route) => RideCard(
            route: route,
            currentUser: client!,
            showReservationButton: canReserveForTrip(route.time),
          )));
    }

    // Adding title and routes for trips ending at AinShams
    List<CarpoolRoute> routesToAinShams =
        routes.where((route) => route.endLocation == 'AinShams').toList();
    if (routesToAinShams.isNotEmpty) {
      routeWidgets.add(
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text('Trips ending at AinShams',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      routeWidgets.addAll(routesToAinShams.map((route) => RideCard(
            route: route,
            currentUser: client!,
            showReservationButton: canReserveForTrip(route.time),
          )));
    }

    return ListView(
      children: routeWidgets,
    );
  }
}
