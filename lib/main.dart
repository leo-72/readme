import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:readme/utils/custom_color.dart';
import 'package:readme/utils/splash_screen.dart';

import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ReadMeApp());
}

class ReadMeApp extends StatefulWidget {
  const ReadMeApp({super.key});

  @override
  State<ReadMeApp> createState() => _ReadMeAppState();
}

class _ReadMeAppState extends State<ReadMeApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: CustomColor.primaryColor),
      home: const SplashScreen(),
    );
  }
}
