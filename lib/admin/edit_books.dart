import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readme/admin/navigation_menu_admin.dart';

import '../models/books.dart';
import '../utils/custom_color.dart';

class EditBooks extends StatefulWidget {
  final Books book;

  const EditBooks({super.key, required this.book});

  @override
  State<EditBooks> createState() => _EditBooksState();
}

class _EditBooksState extends State<EditBooks> {
  File? _image;
  final picker = ImagePicker();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _writerController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _descriptionController =
        TextEditingController(text: widget.book.description);
    _writerController = TextEditingController(text: widget.book.writer);
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> updateBook() async {
    try {
      if (_image != null) {
        final firebase_storage.Reference storageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(
                'images/${DateTime.now().millisecondsSinceEpoch.toString()}');

        final firebase_storage.SettableMetadata metadata =
            firebase_storage.SettableMetadata(contentType: 'image/jpeg');

        await storageRef.putFile(_image!, metadata);
        String imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('lists')
            .doc(widget.book.id)
            .update({
          'image': imageUrl,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'writer': _writerController.text,
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Buku berhasil diperbarui!'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih gambar terlebih dahulu!'),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $error'),
          ),
        );
      }
    }
  }

  Future<void> deleteBook() async {
    try {
      // Hapus buku dari koleksi 'lists'
      await FirebaseFirestore.instance
          .collection('lists')
          .doc(widget.book.id)
          .delete();

      // Ambil referensi ke setiap dokumen di koleksi 'users'
      var userDocs = await FirebaseFirestore.instance.collection('users').get();

      // Loop melalui setiap dokumen user dan hapus buku dari koleksi favorit
      userDocs.docs.forEach((userDoc) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userDoc.id)
            .collection('favorites')
            .where('id', isEqualTo: widget.book.id)
            .get()
            .then((snapshot) {
          snapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Buku berhasil dihapus!'),
          ),
        );
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NavigationMenuAdmin()));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $error'),
          ),
        );
      }
    }
  }

  Widget displaySelectedImage() {
    if (_image != null) {
      return Image.file(_image!);
    } else {
      return Container(
        height: 200,
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: const Icon(Icons.add_a_photo),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: CustomColor.primaryColor,
          title: const Text(
            'Edit Book',
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w600,
                color: Colors.white),
          )),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: getImage,
              child: displaySelectedImage(),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'ClashGrotesk'),
              controller: _titleController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: CustomColor.primaryColor),
                ),
                hintText: 'Judul',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'ClashGrotesk'),
              controller: _descriptionController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: CustomColor.primaryColor),
                ),
                hintText: 'Deskripsi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'ClashGrotesk'),
              controller: _writerController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: CustomColor.primaryColor),
                ),
                hintText: 'Penulis',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: updateBook,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                foregroundColor: Colors.white, backgroundColor: CustomColor.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Perbarui Buku'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: deleteBook,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                foregroundColor: Colors.white, backgroundColor: CustomColor.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Hapus Buku'),
            ),
          ],
        ),
      ),
    );
  }
}
