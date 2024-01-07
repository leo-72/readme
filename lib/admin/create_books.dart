import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readme/screens/login_screen.dart';

import '../utils/custom_color.dart';

class CreateBooks extends StatefulWidget {
  const CreateBooks({super.key});

  @override
  State<CreateBooks> createState() => _CreateBooksState();
}

class _CreateBooksState extends State<CreateBooks> {
  File? _image;
  final picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _writerController = TextEditingController();

  Future<void> _signOut() async {
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

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> addBook() async {
    try {
      if (_image != null) {
        final firebase_storage.Reference storageRef =
            firebase_storage.FirebaseStorage.instance.ref().child(
                'images/${DateTime.now().millisecondsSinceEpoch.toString()}');

        // Tentukan metadata untuk gambar yang diunggah (format jpg/jpeg)
        final firebase_storage.SettableMetadata metadata =
            firebase_storage.SettableMetadata(contentType: 'image/jpeg');

        await storageRef.putFile(
            _image!, metadata); // Sertakan metadata saat memanggil putFile()
        String imageUrl = await storageRef.getDownloadURL();

        CollectionReference booksRef =
            FirebaseFirestore.instance.collection('lists');

        DocumentReference newBookRef = await booksRef.add({
          'image': imageUrl,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'writer': _writerController.text,
        });

        String newBookId =
            newBookRef.id; // Get the ID of the newly created document

        await newBookRef.update({
          'id': newBookId, // Use the document ID as the book's ID
        });

        const CircularProgressIndicator();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Buku berhasil ditambahkan!'),
            ),
          );
        }

        setState(() {
          _image = null;
          _titleController.clear();
          _descriptionController.clear();
          _writerController.clear();
        });
      } else {
        const CircularProgressIndicator();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pilih gambar terlebih dahulu!'),
          ),
        );
      }
    } catch (error) {
      const CircularProgressIndicator();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $error'),
          ),
        );
      }
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
                  _signOut();
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
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomColor.primaryColor,
        title: const Text(
          'Create Books',
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: signOutConfirmation,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: getImage,
              child: _image != null
                  ? Image.file(_image!)
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.add_a_photo),
                    ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'ClashGrotesk'),
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'ClashGrotesk'),
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'ClashGrotesk'),
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addBook,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                foregroundColor: Colors.white,
                backgroundColor: CustomColor.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Tambahkan Buku'),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
