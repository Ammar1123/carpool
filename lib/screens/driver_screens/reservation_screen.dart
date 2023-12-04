import 'package:carpool/models/client.dart';
import 'package:carpool/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:carpool/models/order.dart';
import 'package:carpool/services/order_service.dart';

class ReservationsScreen extends StatefulWidget {
  final Client currentUser;
  const ReservationsScreen({Key? key, required this.currentUser})
      : super(key: key);

  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final OrderService orderService = OrderService();
  final AuthService authService = AuthService();
  bool actionTaken = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations for ${widget.currentUser.name}'),
      ),
      body: StreamBuilder<List<Order>>(
        stream: orderService.getDriverPendingOrders(widget.currentUser.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong: ${snapshot.error}');
          }

          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data;

          if (orders!.isEmpty) {
            return const Center(
              child: Text('No pending reservations for you.'),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(top: 10, left: 5),
            child: Column(
              children: orders.map((order) {
                // Check if the user has taken action on this order
                bool hasTakenAction = actionTaken;

                return Visibility(
                  visible: !hasTakenAction, // Hide if action has been taken
                  child: ListTile(
                    title: Text('Order ID: ${order.id}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Route: ${order.title}'),
                        FutureBuilder<Client?>(
                          future: authService.getClientById(order.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Name: Loading...');
                            }
                            if (snapshot.hasError || snapshot.data == null) {
                              return const Text('Name: Not found');
                            }
                            Client client = snapshot.data!;
                            return Text('Client Name: ${client.name}');
                          },
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Implement logic to approve the reservation
                            orderService.approveOrder(order.id);
                            // Set actionTaken to true when action is taken
                            setState(() {
                              actionTaken = true;
                            });
                          },
                          child: const Text('Approve'),
                        ),
                        const SizedBox(
                            width: 8), // A little space between the buttons
                        ElevatedButton(
                          onPressed: () {
                            // Implement logic to decline the reservation
                            orderService.declineOrder(order.id);
                            // Set actionTaken to true when action is taken
                            setState(() {
                              actionTaken = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors
                                .red, // Optional: Change the color to indicate a decline action
                          ),
                          child: const Text('Decline'),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
