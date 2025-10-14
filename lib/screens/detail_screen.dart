import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/news.dart';
import '../utils/local_storage.dart';

class DetailScreen extends StatefulWidget {
  final News news;
  const DetailScreen({super.key, required this.news});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late News news;

  @override
  void initState() {
    super.initState();
    news = widget.news;
  }

  void _toggle() async {
    await LocalStorage.toggleBookmark(news);
    final updated = LocalStorage.getAllNews()
        .firstWhere((n) => n.id == news.id, orElse: () => news);
    setState(() {
      news = updated;
    });
  }

  void _share() {
    Share.share(
      '${news.title}\n\n${news.description}\n\nSumber: ${news.source}',
      subject: 'Berita dari NéuraNews',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6D83F2),
      appBar: AppBar(
        title: Text(news.source),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _share,
          ),
          IconButton(
            icon: Icon(
              news.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.white,
            ),
            onPressed: _toggle,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              news.imageUrl.startsWith('http')
                  ? news.imageUrl
                  : 'https://picsum.photos/400/200?random=${news.id}',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.white.withOpacity(0.1),
                child: const Icon(Icons.broken_image, color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(news.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Published: ${news.publishedAt}',
              style: const TextStyle(color: Colors.white70)),
          const Divider(color: Colors.white24),
          Text(news.description,
              style:
                  const TextStyle(color: Colors.white70, height: 1.4, fontSize: 15)),
        ],
      ),
    );
  }
}
