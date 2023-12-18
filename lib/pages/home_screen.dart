import 'package:carpool/models/order.dart';
import 'package:carpool/models/route.dart';
import 'package:carpool/models/client.dart';
import 'package:carpool/services/auth_service.dart';
import 'package:carpool/services/order_service.dart';
import 'package:carpool/services/route_service.dart'; // Import the RouteService
import 'package:carpool/pages/ride_card_widget.dart';
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
  final OrderService orderService = OrderService(); // Initialize OrderService
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

          return StreamBuilder<List<Order>>(
            stream: orderService.getClientOrders(client!.id),
            builder: (context, orderSnapshot) {
              if (orderSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              List<String> reservedRouteIds = orderSnapshot.hasData
                  ? orderSnapshot.data!.map((order) => order.routeId).toList()
                  : [];

              return StreamBuilder<List<CarpoolRoute>>(
                stream: routeService.getAllRoutes(),
                builder: (context, routeSnapshot) {
                  if (routeSnapshot.hasError) {
                    return Text('Something went wrong: ${routeSnapshot.error}');
                  }

                  if (!routeSnapshot.hasData ||
                      routeSnapshot.connectionState ==
                          ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<CarpoolRoute> availableRoutes = routeSnapshot.data ?? [];
                  // Filter out reserved routes
                  availableRoutes = availableRoutes
                      .where((route) => !reservedRouteIds.contains(route.id))
                      .toList();

                  return Scaffold(
                      appBar: AppBar(
                        toolbarHeight: 60,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome back',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              client.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      body: _buildRoutesList(availableRoutes, client));
                },
              );
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(''),
            const SizedBox(
              width: 40,
            ),
            const Text('From AinShams',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(width: 20),
            IconButton(
                onPressed: () {
                  setState(() {
                    isReservationFunctionEnabled =
                        !isReservationFunctionEnabled;
                  });
                },
                icon: const Icon(Icons.filter_list, color: Colors.white))
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text('Ending at AinShams',
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
