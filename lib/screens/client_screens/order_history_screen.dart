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
                title: const Text('Order History Page'),
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

  ListTile _buildOrderTile(Order order) {
    Color statusColor; // Declare a variable for status text color

    // Assign color based on order status
    switch (order.status) {
      case 'pending':
        statusColor = Colors.yellow;
        break;
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'declined':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey; // Default color for other statuses
    }

    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      title: Text(
        order.title,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: 'Status: ',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            TextSpan(
              text: order.status,
              style: TextStyle(fontSize: 18, color: statusColor),
            ),
            TextSpan(
              text:
                  '\nDriver: ${order.driverName} \nTime: ${DateFormat("d MMM -- h:mm a").format(order.time)}',
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
