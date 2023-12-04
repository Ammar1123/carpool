import 'package:carpool/models/client.dart';
import 'package:carpool/models/route.dart';
import 'package:carpool/screens/client_screens/ride_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RideCard extends StatelessWidget {
  final Client currentUser;
  final CarpoolRoute route;
  final bool showReservationButton; // New parameter

  const RideCard({
    Key? key,
    required this.route,
    required this.currentUser,
    this.showReservationButton = true, // Default to true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${route.startLocation} to ${route.endLocation}',
              style: const TextStyle(fontSize: 18, color: Colors.yellow),
            ),
            Text(
              'Time: ${DateFormat("d MMM").format(route.time)} ---> ${DateFormat("h:mm a").format(route.time)}',
              style: const TextStyle(color: Colors.yellow),
            ),
            Text('Price: ${route.price}',
                style: const TextStyle(color: Colors.yellow)),
            Text('Driver: ${route.driverName}',
                style: const TextStyle(color: Colors.yellow)),
            if (showReservationButton) // Conditionally display the button
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RideDetailsPage(
                          route: route,
                          currentUser: currentUser,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // Background color
                  ),
                  child: const Text('Reserve'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
