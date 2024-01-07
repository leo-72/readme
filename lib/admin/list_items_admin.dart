import 'package:flutter/material.dart';
import 'package:readme/models/books.dart';

class ListItemsAdmin extends StatefulWidget {
  final Books books;

  const ListItemsAdmin({super.key, required this.books});

  @override
  State<StatefulWidget> createState() => _ListItemsAdminState();
}

class _ListItemsAdminState extends State<ListItemsAdmin> {
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
                          fontSize: 18,
                          fontFamily: 'ClashGrotesk',
                          fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.books.writer,
                      style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'ClashGrotesk',
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
