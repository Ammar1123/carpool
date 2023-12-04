import 'package:carpool/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Screen'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: RegisterForm(), // Create a separate RegisterForm widget
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
              labelStyle: const TextStyle(color: Colors.black),
            ),
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              // Validate email format
              final emailRegex = RegExp(r'^\w+@eng\.asu\.edu\.eg$');
              if (!emailRegex.hasMatch(value)) {
                return 'Enter a valid ASU email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              fillColor: Colors.yellow,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              labelStyle: const TextStyle(color: Colors.black),
            ),
            style: const TextStyle(color: Colors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username is required';
              }
              return null;
            },
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
              labelStyle: const TextStyle(color: Colors.black),
            ),
            obscureText: true,
            style: const TextStyle(color: Colors.black),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // All fields are valid, perform registration
                AuthService().registerWithEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                  _usernameController.text,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.yellow, // Button text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
