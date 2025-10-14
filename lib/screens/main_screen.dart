import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'bookmark_screen.dart';
import 'discover_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String userName; // 🔹 tambah parameter biar bisa nerima nama dari Welcome

  const MainScreen({super.key, required this.userName});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 🔹 bikin list screens di dalam build supaya bisa akses widget.userName
    final screens = [
      const HomeScreen(),
      const BookmarkScreen(),
      const DiscoverScreen(),
      ProfileScreen(userName: widget.userName), // 🔹 kirim nama ke profil
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF6D83F2),
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white.withOpacity(0.15),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Tersimpan'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Temukan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
