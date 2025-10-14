// lib/screens/bookmark_screen.dart
import 'package:flutter/material.dart';
import '../models/news.dart';
import '../utils/local_storage.dart';
import 'detail_screen.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<News> bookmarks = [];

  @override
  void initState() {
    super.initState();
    LocalStorage.newsNotifier.addListener(_reload);
    _reload();
  }

  void _reload() {
    setState(() {
      bookmarks = LocalStorage.getBookmarked();
    });
  }

  @override
  void dispose() {
    LocalStorage.newsNotifier.removeListener(_reload);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6D83F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🔖 Berita Tersimpan',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: bookmarks.isEmpty
                    ? const Center(
                        child: Text('Belum ada berita yang disimpan',
                            style: TextStyle(color: Colors.white70)),
                      )
                    : ListView.builder(
                        itemCount: bookmarks.length,
                        itemBuilder: (context, i) {
                          final n = bookmarks[i];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              color: Colors.white.withOpacity(0.08),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    n.imageUrl,
                                    width: 100,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(n.title,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                subtitle: Text(n.source,
                                    style: const TextStyle(
                                        color: Colors.white70)),
                                trailing: IconButton(
                                  icon: Icon(
                                    n.isBookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      LocalStorage.toggleBookmark(n),
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailScreen(news: n),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
