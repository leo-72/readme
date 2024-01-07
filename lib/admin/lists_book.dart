import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:readme/admin/edit_books.dart';
import 'package:readme/admin/list_items_admin.dart';

import '../models/books.dart';
import '../utils/custom_color.dart';

class ListsBook extends StatefulWidget {
  const ListsBook({super.key});

  @override
  State<StatefulWidget> createState() => _ListsBookState();
}

class _ListsBookState extends State<ListsBook> {
  void _navigateToEditBooks(BuildContext context, Books book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditBooks(book: book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomColor.primaryColor,
        title: const Center(
          child: Text(
            'Lists Book',
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
        ),
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
                    _navigateToEditBooks(context, book);
                  },
                  child: ListItemsAdmin(books: book),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
