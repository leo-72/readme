import 'package:flutter/material.dart';
import 'package:readme/admin/create_books.dart';
import 'package:readme/admin/list_items_admin.dart';
import 'package:readme/admin/lists_book.dart';

import '../utils/custom_color.dart';

class NavigationMenuAdmin extends StatefulWidget{
  const NavigationMenuAdmin({super.key});

  @override
  State<NavigationMenuAdmin> createState() => _NavigationMenuAdminState();
}

class _NavigationMenuAdminState extends State<NavigationMenuAdmin> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const ListsBook(),
    const CreateBooks(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      extendBody: true,
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        items: _items,
        iconSize: 25,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: CustomColor.primaryColor,
        showUnselectedLabels: true,
        selectedFontSize: 12,
      ),
    );
  }

  final List<BottomNavigationBarItem> _items = [
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Icon(Icons.menu_book_rounded),
      ),
      label: "Lists Book",
    ),
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Icon(Icons.create_rounded),
      ),
      label: "Create Book",
    ),
  ];
}