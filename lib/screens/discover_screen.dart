// lib/screens/discover_screen.dart
import 'package:flutter/material.dart';
import '../models/news.dart';
import '../utils/local_storage.dart';
import 'detail_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String selectedCategory = 'Semua';
  List<News> all = [];

  @override
  void initState() {
    super.initState();
    LocalStorage.newsNotifier.addListener(_onNewsChanged);
    _onNewsChanged();
  }

  void _onNewsChanged() {
    setState(() {
      all = LocalStorage.getAllNews();
    });
  }

  @override
  void dispose() {
    LocalStorage.newsNotifier.removeListener(_onNewsChanged);
    _searchCtrl.dispose();
    super.dispose();
  }

  List<News> get filtered {
    final q = _searchCtrl.text.toLowerCase();
    return all.where((news) {
      final matchesQuery = news.title.toLowerCase().contains(q) ||
          news.description.toLowerCase().contains(q);
      final matchesCategory = selectedCategory == 'Semua'
          ? true
          : news.title
              .toLowerCase()
              .contains(selectedCategory.toLowerCase());
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['Semua', 'Teknologi', 'Dunia', 'Islami', 'Lifestyle'];

    return Scaffold(
      backgroundColor: const Color(0xFF6D83F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🔎 Temukan Berita',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Cari berita...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSelected = cat == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          cat,
                          style: TextStyle(
                              color: isSelected
                                  ? const Color.fromARGB(255, 42, 1, 78)
                                  : Colors.white70,
                              fontWeight:
                                  isSelected ? FontWeight.bold : null),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF8E54E9),
                        backgroundColor: Colors.white.withOpacity(0.08),
                        onSelected: (_) =>
                            setState(() => selectedCategory = cat),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text('Berita tidak ditemukan',
                            style: TextStyle(color: Colors.white70)),
                      )
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final n = filtered[i];
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
