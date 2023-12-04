import 'package:carpool/models/route.dart';
import 'package:carpool/models/client.dart';
import 'package:carpool/services/route_service.dart'; // Import the RouteService
import 'package:carpool/utils/constants.dart';
import 'package:carpool/widgets/ride_card_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final Client currentUser;
  const HomeScreen({super.key, required this.currentUser});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RouteService routeService = RouteService(); // Initialize RouteService
  List<CarpoolRoute> availableRoutes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text('Welcome back ${widget.currentUser.name}'),
        centerTitle: true,
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

          List<Widget> items = [];

          items.add(const Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text('Routes Starting from AinShams : ',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ));
          items.addAll(availableRoutes
              .where((route) => route.startLocation == 'AinShams')
              .map((route) {
            return buildRouteTile(route, context);
          }).toList());

          items.add(const Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text('Routes Ending at AinShams :',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ));
          items.addAll(availableRoutes
              .where((route) => route.endLocation == 'AinShams')
              .map((route) {
            return buildRouteTile(route, context);
          }).toList());

          return ListView(
            children: items,
          );
        },
      ),
    );
  }

  Widget buildRouteTile(CarpoolRoute route, BuildContext context) {
    return RideCard(route: route, currentUser: widget.currentUser,showReservationButton: true,);
  }
}
