import 'package:carpool/app/main_client_app.dart';
import 'package:carpool/app/main_driver_app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                  height: 150, // Adjust as needed
                  width: 160, // Adjust as needed
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'lib/assets/carpool.png'), // Replace with your image
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    fillColor: Colors.yellow,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelStyle: const TextStyle(
                        color: Colors.black), // Black text for label
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                      color: Colors.black), // Black text for input
                  // ... Validator ...
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    fillColor: Colors.yellow,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelStyle: const TextStyle(
                        color: Colors.black), // Black text for label
                  ),
                  obscureText: true,
                  style: const TextStyle(
                      color: Colors.black), // Black text for input
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => performLogin(role: "client"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(150, 50), // Adjust the size as needed
                      ),
                      child: const Text('Login as Client'),
                    ),
                    ElevatedButton(
                      onPressed: () => performLogin(role: "driver"),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(150, 50), // Adjust the size as needed
                      ),
                      child: const Text('Login as Driver'),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: const Text('Don\'t have an account? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> performLogin({required String role}) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Navigate based on the role after successful authentication
        if (role == "client") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainClientApp(),
              )); // Replace with your client home route
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainDriverApp(),
              )); // Replace with your driver home route
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to login"),
          ),
        );
      }
    }
  }
}
