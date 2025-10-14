import 'package:flutter/material.dart';
import '../models/news.dart';
import 'news_card.dart';

class NewsListView extends StatelessWidget {
  final List<News> newsList;

  const NewsListView({Key? key, required this.newsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (newsList.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada berita 😔',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final news = newsList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: NewsCard(
            news: news,
            onTap: () {
              // nanti diarahkan ke detail screen
            },
          ),
        );
      },
    );
  }
}
