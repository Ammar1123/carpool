// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBVj5hYfrb1yOAJg6ASQ9Yy7yZOUAY6tnA',
    appId: '1:305756309732:web:7199bc5e9e4c9646c604f1',
    messagingSenderId: '305756309732',
    projectId: 'carpool-c5ea2',
    authDomain: 'carpool-c5ea2.firebaseapp.com',
    storageBucket: 'carpool-c5ea2.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAwsjg-HKInG3ZuVSRLvgol7TtJcIsXQMw',
    appId: '1:305756309732:android:b74f126cb3d5393cc604f1',
    messagingSenderId: '305756309732',
    projectId: 'carpool-c5ea2',
    storageBucket: 'carpool-c5ea2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFmLAEmfk85Qlhs6hD1i_j9DHdUsTLbss',
    appId: '1:305756309732:ios:c7a1ae6963adab92c604f1',
    messagingSenderId: '305756309732',
    projectId: 'carpool-c5ea2',
    storageBucket: 'carpool-c5ea2.appspot.com',
    iosBundleId: 'com.example.carpool',
  );
}