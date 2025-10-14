// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/news.dart';
import '../utils/local_storage.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6D83F2),
      body: SafeArea(
        child: ValueListenableBuilder<List<News>>(
          valueListenable: LocalStorage.newsNotifier,
          builder: (context, list, _) {
            if (list.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                const Text(
                  '🧠 NéuraNews',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 20),
                // breaking: first 3
                if (list.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length >= 3 ? 3 : list.length,
                      itemBuilder: (context, idx) {
                        final n = list[idx];
                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(news: n))),
                          child: Container(
                            width: 300,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(n.imageUrl, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 30),
                const Text('🌍 Semua Berita', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 16),
                ...list.map((news) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        color: Colors.white.withOpacity(0.08),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(news.imageUrl, width: 100, fit: BoxFit.cover),
                          ),
                          title: Text(news.title, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(news.source, style: const TextStyle(color: Colors.white70)),
                          trailing: IconButton(
                            icon: Icon(news.isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: Colors.white),
                            onPressed: () => LocalStorage.toggleBookmark(news),
                          ),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(news: news))),
                        ),
                      ),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }
}
