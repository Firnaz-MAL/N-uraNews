import 'package:flutter/material.dart';
import '../../models/news.dart';
import '../../utils/local_storage.dart';
import '../../widgets/admin_card.dart';
import '../admin/edit_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    LocalStorage.init(); // Pastikan data dimuat dari JSON
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D83F2), Color(0xFF8E54E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ValueListenableBuilder<List<News>>(
            valueListenable: LocalStorage.newsNotifier,
            builder: (context, allNews, _) {
              if (allNews.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Dashboard Admin',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kelola dan pantau berita terbaru dengan mudah',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: allNews.length,
                        itemBuilder: (context, index) {
                          final news = allNews[index];
                          return AdminCard(
                            news: news,
                            onEdit: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditScreen(news: news),
                                ),
                              );

                              if (result != null && result is News) {
                                LocalStorage.updateNews(result);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF6D83F2),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Berita'),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditScreen()),
          );

          if (result != null && result is News) {
            // Tambahkan berita baru ke list
            final updatedList = List<News>.from(LocalStorage.newsNotifier.value)
              ..insert(0, result);
            LocalStorage.newsNotifier.value = updatedList;
          }
        },
      ),
    );
  }
}
