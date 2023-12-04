class Client {
  final String id;
  final String name;
  final String email;
  final double balance;
  final String clientImageUrl; // New field for client's image URL

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.balance,
    required this.clientImageUrl, // Include this in the constructor
  });

  // Convert a Client into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'balance': balance,
      'clientImageUrl': clientImageUrl, // Add clientImageUrl to the map
    };
  }

  // Create a Client from a Map
  static Client fromMap(Map<String, dynamic> map) {
    double balance = (map['balance'] is int)
        ? (map['balance'] as int).toDouble()
        : map['balance'];

    return Client(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      balance: balance,
      clientImageUrl:
          map['clientImageUrl'], // Retrieve clientImageUrl from the map
    );
  }
}
