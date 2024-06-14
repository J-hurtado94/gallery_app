// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDNkiqMG0Hyo_ZWZPtwM039aqkcv9LXREQ',
    appId: '1:597070785749:web:a531426977771a929e065c',
    messagingSenderId: '597070785749',
    projectId: 'gallery-app-8135a',
    authDomain: 'gallery-app-8135a.firebaseapp.com',
    storageBucket: 'gallery-app-8135a.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBOKCI42PVQR0OXDcQPgyEi0uNwf7PUU4Q',
    appId: '1:597070785749:android:160087b750b5eb919e065c',
    messagingSenderId: '597070785749',
    projectId: 'gallery-app-8135a',
    storageBucket: 'gallery-app-8135a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAk2UPP57IY3lOWCeeOcPx-PkF6MtKKGmc',
    appId: '1:597070785749:ios:c199fa4c1ce698819e065c',
    messagingSenderId: '597070785749',
    projectId: 'gallery-app-8135a',
    storageBucket: 'gallery-app-8135a.appspot.com',
    iosBundleId: 'com.example.galleryApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAk2UPP57IY3lOWCeeOcPx-PkF6MtKKGmc',
    appId: '1:597070785749:ios:c199fa4c1ce698819e065c',
    messagingSenderId: '597070785749',
    projectId: 'gallery-app-8135a',
    storageBucket: 'gallery-app-8135a.appspot.com',
    iosBundleId: 'com.example.galleryApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDNkiqMG0Hyo_ZWZPtwM039aqkcv9LXREQ',
    appId: '1:597070785749:web:b7218eb6965e6dee9e065c',
    messagingSenderId: '597070785749',
    projectId: 'gallery-app-8135a',
    authDomain: 'gallery-app-8135a.firebaseapp.com',
    storageBucket: 'gallery-app-8135a.appspot.com',
  );
}
