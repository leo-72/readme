import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:readme/models/list_favorites.dart';

import '../utils/custom_color.dart';
import '../screens/book_details.dart';
import '../models/books.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  void _navigateToBookDetails(BuildContext context, Books book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetails(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        title: const Center(
            child: Text(
          'Favorites',
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              color: Colors.white),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('favorites')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Lottie.asset(
                  'lib/images/no_data.json',
                  // Sesuaikan dengan path animasi Lottie
                  width: 350,
                  height: 350,
                  fit: BoxFit.cover,
                  repeat: false,
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot<Object?> doc = snapshot.data!.docs[index];
                Books book = Books(
                  id: doc.id,
                  title: doc['title'] ?? '',
                  description: doc['description'] ?? '',
                  writer: doc['writer'] ?? '',
                  image: doc['image'] ?? '',
                );

                return InkWell(
                  onTap: () {
                    _navigateToBookDetails(context, book);
                  },
                  child: ListFavorites(books: book),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
