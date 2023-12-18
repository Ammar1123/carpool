import 'package:carpool/models/client.dart';
import 'package:carpool/models/route.dart';
import 'package:carpool/pages/screens/ride_details.dart';
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
    // Format the date and time
    final String formattedDate = DateFormat("dd/MM/yyyy").format(route.time);
    final String formattedTime = DateFormat("h:mm a").format(route.time);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.purple),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${route.startLocation} to ${route.endLocation}',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Time: $formattedTime',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.attach_money, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Price: ${route.price}',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Driver: ${route.driverName}',
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
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
                      backgroundColor: Colors.purple, // Background color
                    ),
                    child: const Text('Reserve'),
                  ),
                ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Date: $formattedDate',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
