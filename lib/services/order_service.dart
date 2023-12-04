import 'package:carpool/models/order.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> addNewOrder(Order route) async {
    DatabaseReference newRouteRef = _dbRef.child('orders').push();
    await newRouteRef.set(route.toMap());
  }

  Future<void> approveOrder(String orderId) async {
    await _dbRef.child('orders').child(orderId).update({'status': 'approved'});
  }

  Future<void> declineOrder(String orderId) async {
    await _dbRef.child('orders').child(orderId).update({'status': 'declined'});
  }

  Stream<List<Order>> getAllOrders() {
    return _dbRef.child('orders').onValue.map((event) {
      var snapshot = event.snapshot;
      List<Order> orders = [];
      if (snapshot.value is Map) {
        Map<String, dynamic> routesMap =
            Map<String, dynamic>.from(snapshot.value as Map);
        routesMap.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> valueMap = Map<String, dynamic>.from(value);
            valueMap['id'] = key;
            orders.add(Order.fromMap(valueMap));
          }
        });
      }
      return orders;
    });
  }

  Stream<List<Order>> getClientOrders(String clientId) {
    return _dbRef
        .child('orders')
        .orderByChild('userId')
        .equalTo(clientId)
        .onValue
        .map((event) {
      var snapshot = event.snapshot;
      List<Order> orders = [];
      if (snapshot.value is Map) {
        Map<String, dynamic> ordersMap =
            Map<String, dynamic>.from(snapshot.value as Map);
        ordersMap.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> valueMap = Map<String, dynamic>.from(value);
            valueMap['id'] = key;
            Order order = Order.fromMap(valueMap);

            DateTime now = DateTime.now();
            DateTime rideDate =
                order.time; // Replace 'rideDate' with the actual field name

            // Check if the ride date is before or after the current time
            if (rideDate.isBefore(now) || rideDate.isAtSameMomentAs(now)) {
              // This order is a past ride
              orders.add(order);
            } else {
              // This order is an upcoming ride
              orders.add(order);
            }
          }
        });
      }
      return orders;
    });
  }

  Stream<List<Order>> getDriverPendingOrders(String driverId) {
    return _dbRef
        .child('orders')
        .orderByChild('driverId')
        .equalTo(driverId)
        .onValue
        .map((event) {
      var snapshot = event.snapshot;
      List<Order> orders = [];
      if (snapshot.value is Map) {
        Map<String, dynamic> ordersMap =
            Map<String, dynamic>.from(snapshot.value as Map);
        ordersMap.forEach((key, value) {
          if (value is Map) {
            Map<String, dynamic> valueMap = Map<String, dynamic>.from(value);
            valueMap['id'] = key;
            orders.add(Order.fromMap(valueMap));
          }
        });
      }
      return orders.where((order) => order.status == 'pending').toList();
    });
  }
}
