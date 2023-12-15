import 'package:carpool/models/client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with Email and Password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateUserBalance(String userId, double newBalance) async {
    try {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      await userRef.update({'balance': newBalance});
    } catch (e) {
      print(e);
      // Handle the error appropriately
    }
  }

  // Register with Email and Password
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successful registration, store user data in Firestore
      if (userCredential.user != null) {
        await saveUserDataToFirestore(
          userCredential.user!.uid, // Use Firebase UID as Firestore document ID
          email,
          username,
          'https://upload.wikimedia.org/wikipedia/commons/9/9b/Cat_crying.jpg',
          500,
          // Add other user data fields here
        );
      }

      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<Client?> getClientById(String clientId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(clientId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Create a Client object from the fetched data
        Client client = Client(
          id: clientId,
          name: userData['name'] ?? '', // Replace with the actual field name
          email: userData['email'] ?? '', // Replace with the actual field name
          balance: userData['balance'] ?? 0,
          clientImageUrl: userData['clientImageUrl'] ?? '',

          // Initialize other properties based on your data structure
        );

        return client;
      } else {
        // User does not exist in Firestore
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Get current user
  Future<Client?> getClient() async {
    try {
      final User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          double balance = 0;
          if (userData.containsKey('balance')) {
            balance = (userData['balance'] is int)
                ? (userData['balance'] as int).toDouble()
                : (userData['balance'] as double);
          }
          // Create a Client object from the fetched data
          Client client = Client(
            id: user.uid,
            name: userData['name'] ?? '', // Replace with the actual field name
            email:
                userData['email'] ?? '', // Replace with the actual field name
            balance: balance,
            clientImageUrl: userData['clientImageUrl'] ?? '',
            // Initialize other properties based on your data structure
          );

          return client;
        } else {
          // User does not exist in Firestore
          return null;
        }
      } else {
        // No authenticated user
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Save user data to Firestore
  Future<void> saveUserDataToFirestore(String uid, String email,
      String username, String clientImageUrl, double balance) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot userDoc = await userRef.get();
    try {
      if (userDoc.exists) {
        return;
      }
      // User does not exist in Firestore, create new document
      if (!userDoc.exists) {
        await userRef.set({
          'email': email,
          'name': username, // Use email as default name
          'clientImageUrl': clientImageUrl,
          'balance': balance,
          // Add other user data fields here
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print(e);
    }
  }

  // Get current user
}
