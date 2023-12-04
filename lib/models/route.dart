class CarpoolRoute {
  final String id;
  final String startLocation;
  final String endLocation;
  final DateTime time;
  final double price;
  final String driverName; // New field for driver's name
  final String driverId; // New field for driver's ID

  CarpoolRoute({
    required this.id,
    required this.startLocation,
    required this.endLocation,
    required this.time,
    required this.price,
    required this.driverName, // Initialize in constructor
    required this.driverId, // Initialize in constructor
  });

  // Convert a CarpoolRoute into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'time': time.toIso8601String(),
      'price': price,
      'driverName': driverName, // Add driverName to Map
      'driverId': driverId, // Add driverId to Map
    };
  }

  // Create a CarpoolRoute from a Map
  static CarpoolRoute fromMap(Map<String, dynamic> map) {
    double price =
        (map['price'] is int) ? (map['price'] as int).toDouble() : map['price'];

    return CarpoolRoute(
      id: map['id'],
      startLocation: map['startLocation'],
      endLocation: map['endLocation'],
      time: DateTime.parse(map['time']),
      price: price,
      driverName: map['driverName'], // Retrieve driverName from Map
      driverId: map['driverId'], // Retrieve driverId from Map
    );
  }
}
