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
    apiKey: 'AIzaSyA0speI3LYWTU_XZ1uyzQZJsd-pkpbURB8',
    appId: '1:18229323928:web:b3adc0f0bf0c9af2e888ed',
    messagingSenderId: '18229323928',
    projectId: 'readme-d460d',
    authDomain: 'readme-d460d.firebaseapp.com',
    storageBucket: 'readme-d460d.appspot.com',
    measurementId: 'G-GGQ10NBW0F',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB6r_CDiEPXVnPkHT97DhDtfZ6ZpfVjs40',
    appId: '1:18229323928:android:d1aa4f1f2471600be888ed',
    messagingSenderId: '18229323928',
    projectId: 'readme-d460d',
    storageBucket: 'readme-d460d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_d3JFLt49ZS6ghRmQ6aF5FHJT3EzE330',
    appId: '1:18229323928:ios:b52fa1074379e404e888ed',
    messagingSenderId: '18229323928',
    projectId: 'readme-d460d',
    storageBucket: 'readme-d460d.appspot.com',
    iosBundleId: 'com.readme.readme',
  );
}