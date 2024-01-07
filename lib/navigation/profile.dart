import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../utils/custom_color.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigasi ke halaman login setelah keluar
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void signOutConfirmation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Konfirmasi',
              style:
              TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w600),
            ),
            content: const Text('Apakah Anda yakin ingin keluar?', style:
            TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.w300)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                const Text('Batal', style: TextStyle(color: Colors.grey, fontFamily: 'Lexend', fontWeight: FontWeight.w600)),
              ),
              TextButton(
                onPressed: () {
                  signOut();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Keluar',
                  style: TextStyle(color: CustomColor.primaryColor, fontFamily: 'Lexend', fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        title: const Center(
            child: Text(
              'Profile',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              signOutConfirmation();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              foregroundColor: Colors.white,
              backgroundColor: CustomColor.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: const TextStyle(
                fontSize: 16,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Sign Out')),
      ),
    );
  }
}
