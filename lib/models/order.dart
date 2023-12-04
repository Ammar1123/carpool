class Order {
  final String id;
  final String userId;
  final String driverId;
  final String driverName; // New field for driver's name
  final String routeId;
  final String status;
  final DateTime time;
  final String title;

  Order({
    required this.id,
    required this.userId,
    required this.driverId,
    required this.driverName, // Include this in the constructor
    required this.routeId,
    required this.status,
    required this.time,
    required this.title,
  });

  // Convert an Order into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'driverId': driverId,
      'driverName': driverName, // Add driverName to the map
      'routeId': routeId,
      'status': status,
      'time': time.toIso8601String(),
      'title': title,
    };
  }

  // Create an Order from a Map
  static Order fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      userId: map['userId'],
      driverId: map['driverId'],
      driverName: map['driverName'], // Retrieve driverName from the map
      routeId: map['routeId'],
      status: map['status'],
      time: DateTime.parse(map['time']),
      title: map['title'],
    );
  }
}
