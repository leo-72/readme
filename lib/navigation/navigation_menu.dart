import 'package:flutter/material.dart';
import 'package:readme/utils/custom_color.dart';
import 'package:readme/navigation/favorites.dart';
import 'package:readme/navigation/home.dart';
import 'package:readme/navigation/profile.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const Home(),
    const Favorites(),
    const Profile(),
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
        child: Icon(Icons.home_filled),
      ),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Icon(Icons.bookmark_rounded),
      ),
      label: "Favorites",
    ),
    const BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Icon(Icons.person),
      ),
      label: "Profile",
    ),
  ];
}