import 'package:carpool/models/client.dart';
import 'package:carpool/models/order.dart';
import 'package:carpool/models/route.dart';
import 'package:carpool/services/auth_service.dart';
import 'package:carpool/services/order_service.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final Client currentUser;
  final CarpoolRoute route;
  const PaymentScreen(
      {super.key, required this.route, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Payment Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('Enter your credit card details',
                style: TextStyle(
                  textBaseline: TextBaseline.alphabetic,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(
                labelText: 'Credit Card Number',
                fillColor: Colors.purple,
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Expiry Date',
                labelStyle: const TextStyle(color: Colors.white),
                fillColor: Colors.purple,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'CVV',
                labelStyle: const TextStyle(color: Colors.white),
                fillColor: Colors.purple,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity, // Makes the button full-width
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                onPressed: () async {
                  double routeCost =
                      route.price; // Replace with actual cost field

                  if (currentUser.balance >= routeCost) {
                    // Deduct cost from user's balance
                    double newBalance = currentUser.balance - routeCost;
                    await AuthService()
                        .updateUserBalance(currentUser.id, newBalance);

                    // Proceed with order creation
                    Order newOrder = Order(
                        driverName: route.driverName,
                        driverId: route.driverId,
                        id:
                            '$DateTime.now()', // Generate a unique ID for the order
                        userId: currentUser.id,
                        routeId: route.id,
                        status: 'pending',
                        time: route.time,
                        title:
                            '${route.startLocation} to ${route.endLocation}' // The time from the selected route
                        );

                    await OrderService().addNewOrder(newOrder);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment successful. Order created!'),
                      ),
                    );

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', (Route<dynamic> route) => false);
                  } else {
                    // Show an error message if balance is insufficient
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Insufficient balance for this transaction'),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text('Confirm Payment',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
