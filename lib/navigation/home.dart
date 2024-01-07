import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:readme/utils/custom_color.dart';

import '../screens/book_details.dart';
import '../models/books.dart';
import '../models/list_items.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
          'Home',
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
          stream: FirebaseFirestore.instance.collection('lists').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Data.'));
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
                  child: ListItems(books: book),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
