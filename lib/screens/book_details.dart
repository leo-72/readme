import 'package:flutter/material.dart';

import '../models/books.dart';
import '../utils/custom_color.dart';

class BookDetails extends StatelessWidget {
  final Books book;

  const BookDetails({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomColor.primaryColor,
        title: const Text(
          'Book Details',
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    SizedBox(
                        height: 300,
                        width: 200,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child:
                                Image.network(book.image, fit: BoxFit.cover))),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: Column(
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      book.writer,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
              Text(
                book.description,
                style: const TextStyle(fontSize: 16.0),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
