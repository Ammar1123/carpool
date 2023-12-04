import 'package:carpool/models/route.dart';
import 'package:firebase_database/firebase_database.dart';

class RouteService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> addNewRoute(CarpoolRoute route) async {
    DatabaseReference newRouteRef = _dbRef.child('routes').push();
    await newRouteRef.set(route.toMap());
  }
  Future<void> deleteRoute(String routeId) async {
    DatabaseReference routeRef = _dbRef.child('routes').child(routeId);
    await routeRef.remove();
  }
  // Fetch all routes from Realtime Database
  Stream<List<CarpoolRoute>> getAllRoutes() {
    return _dbRef.child('routes').onValue.map((event) {
      var snapshot = event.snapshot;
      List<CarpoolRoute> routes = [];
      if (snapshot.value is Map) {
        Map<String, dynamic> routesMap =
            Map<String, dynamic>.from(snapshot.value as Map);
        routesMap.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> valueMap = Map<String, dynamic>.from(value);
            valueMap['id'] = key;
            routes.add(CarpoolRoute.fromMap(valueMap));
          }
        });
      }
      return routes;
    });
  }
}
