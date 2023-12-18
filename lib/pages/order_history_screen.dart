import 'package:carpool/models/order.dart'; // Import the Order model
import 'package:carpool/models/client.dart';
import 'package:carpool/services/auth_service.dart';
import 'package:carpool/services/order_service.dart'; // Import the OrderService
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderService orderService = OrderService(); // Initialize OrderService
    AuthService authService = AuthService(); // Initialize AuthService

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
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Order History'),
                centerTitle: true,
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Past'),
                  ],
                ),
              ),
              body: StreamBuilder<List<Order>>(
                stream: orderService
                    .getClientOrders(client!.id), // Use getClientOrders
                builder: (BuildContext context,
                    AsyncSnapshot<List<Order>> orderSnapshot) {
                  if (orderSnapshot.hasError) {
                    return Text('Something went wrong: ${orderSnapshot.error}');
                  }

                  if (orderSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<Order> orders = orderSnapshot.data ?? [];
                  DateTime currentTime = DateTime.now();
                  List<Order> upcomingOrders = orders
                      .where((order) =>
                          (order.status == 'approved') ||
                          order.status == 'pending')
                      .toList();
                  List<Order> pastOrders = orders
                      .where((order) =>
                          (order.status == 'complete' &&
                              order.time.isBefore(currentTime)) ||
                          order.status == 'declined')
                      .toList();

                  // TabBarView for Upcoming and Past orders
                  return TabBarView(
                    children: [
                      // Upcoming Orders Tab
                      upcomingOrders.isEmpty
                          ? const Center(child: Text('No upcoming orders'))
                          : ListView.builder(
                              itemCount: upcomingOrders.length,
                              itemBuilder: (context, index) {
                                Order order = upcomingOrders[index];
                                return _buildOrderTile(order);
                              },
                            ),

                      // Past Orders Tab
                      pastOrders.isEmpty
                          ? const Center(child: Text('No past orders'))
                          : ListView.builder(
                              itemCount: pastOrders.length,
                              itemBuilder: (context, index) {
                                Order order = pastOrders[index];
                                return _buildOrderTile(order);
                              },
                            ),
                    ],
                  );
                },
              ),
            ),
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

  Widget _buildOrderTile(Order order) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.purple,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center horizontally
              children: [
                Text(order.title,
                    textAlign: TextAlign.center, // Center the text
                    style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                    height: 10), // Spacing between title and subtitle
                Text(
                    'Status: ${order.status} \nDriver: ${order.driverName} \nTime: ${DateFormat("d MMM -- h:mm a").format(order.time)}',
                    textAlign: TextAlign.center, // Center the text
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
