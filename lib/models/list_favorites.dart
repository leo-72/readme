import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'books.dart';

class ListFavorites extends StatefulWidget {
  final Books books;
  const ListFavorites({super.key, required this.books});

  @override
  State<StatefulWidget> createState() => ListFavoritesState();
}

class ListFavoritesState extends State<ListFavorites> {
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    checkFavoriteStatus();
  }

  Future<void> checkFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
      final favoriteDoc = userDoc.collection('favorites').doc(widget.books.id);

      final docSnapshot = await favoriteDoc.get();

      setState(() {
        _isFav = docSnapshot.exists;
      });
    }
  }

  Future<void> addFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
      final favoriteDoc = userDoc.collection('favorites').doc(widget.books.id);

      await favoriteDoc.set({
        'id': widget.books.id,
        'title': widget.books.title,
        'description': widget.books.description,
        'writer': widget.books.writer,
        'image': widget.books.image,
      });

      setState(() {
        _isFav = true;
      });
    }
  }

  Future<void> removeFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
      FirebaseFirestore.instance.collection('users').doc(user.uid);
      final favoriteDoc = userDoc.collection('favorites').doc(widget.books.id);

      await favoriteDoc.delete();

      checkFavoriteStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Container(
          height: 150,
          padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  widget.books.image,
                  height: 150,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.books.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.books.writer,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    if (_isFav) {
                      await removeFavorite();
                    } else {
                      await addFavorite();
                    }
                  }
                },
                child: Icon(
                  _isFav ? Icons.bookmark : Icons.bookmark_border,
                  color: _isFav ? Colors.red : Colors.grey,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}