import 'package:carpool/app/main_client_app.dart';
import 'package:carpool/firebase_options.dart';
import 'package:carpool/screens/login_screen.dart';
import 'package:carpool/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// All Done
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.yellow, // This sets the default color of the MaterialApp
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          headlineMedium: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          titleSmall: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
          labelSmall: TextStyle(color: Colors.white),
        ),
        primarySwatch: Colors.yellow, // Primary color for your app
        scaffoldBackgroundColor: const Color.fromARGB(
            255, 0, 41, 75), // Default background color for Scaffolds
      ),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const MainClientApp(),
        '/register': (context) => const RegisterScreen(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return const LoginScreen();
            }
            return const MainClientApp();
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
