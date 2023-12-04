import 'package:carpool/models/client.dart';
import 'package:carpool/screens/client_screens/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carpool/models/route.dart';

class RideDetailsPage extends StatelessWidget {
  final Client currentUser;
  final CarpoolRoute route;

  const RideDetailsPage(
      {Key? key, required this.route, required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Details'),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Driver: ${route.driverName}', // Display the driver's name
                    style: const TextStyle(
                        fontSize: 24,
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.yellow),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${route.startLocation} to ${route.endLocation}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time: ${DateFormat("d MMM, h:mm a").format(route.time)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price: ${route.price} EGP',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentScreen(
                                    route: route, currentUser: currentUser),
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.yellow, // Text color
                        ),
                        child: const Text('Reserve Seat'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
