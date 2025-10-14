// lib/utils/local_storage.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news.dart';

class LocalStorage {
  static const _bookmarkKey = 'bookmarked_news';
  static const _localNewsKey = 'local_news_data';
  static const _seedFilePath = 'assets/news_seed.json';
  static SharedPreferences? _prefs;

  /// Notifier untuk semua screen — listen agar UI auto refresh
  static final ValueNotifier<List<News>> newsNotifier = ValueNotifier<List<News>>([]);

  /// Initialize prefs and load seed (call once before runApp or in splash)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadFromAssetsAndApplyBookmarks();
  }

  /// Load JSON from assets or local storage, apply bookmarked flags
  static Future<void> _loadFromAssetsAndApplyBookmarks() async {
    final savedJson = _prefs?.getString(_localNewsKey);

    List<News> list = [];
    if (savedJson != null && savedJson.isNotEmpty) {
      final List<dynamic> decoded = json.decode(savedJson) as List<dynamic>;
      list = decoded.map((e) => News.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      final raw = await rootBundle.loadString(_seedFilePath);
      final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
      list = decoded.map((e) => News.fromJson(e as Map<String, dynamic>)).toList();
    }

    final savedBookmarks = _prefs?.getStringList(_bookmarkKey) ?? [];
    for (var n in list) {
      n.isBookmarked = savedBookmarks.contains(n.id);
    }

    newsNotifier.value = list;
  }

  /// Return current list (fresh from notifier)
  static List<News> getAllNews() => newsNotifier.value;

  /// Force reload (re-read assets and apply bookmarks)
  static Future<void> reload() async {
    await _loadFromAssetsAndApplyBookmarks();
  }

  /// ✅ Simpan semua berita ke local storage
  static Future<void> saveAllNews(List<News> allNews) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(allNews.map((n) => n.toJson()).toList());
    await _prefs!.setString(_localNewsKey, encoded);
    newsNotifier.value = List<News>.from(allNews);
  }

  /// Toggle bookmark for given news and persist state
  static Future<void> toggleBookmark(News news) async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
    final saved = _prefs!.getStringList(_bookmarkKey) ?? [];

    if (saved.contains(news.id)) {
      saved.remove(news.id);
      news.isBookmarked = false;
    } else {
      saved.add(news.id);
      news.isBookmarked = true;
    }
    await _prefs!.setStringList(_bookmarkKey, saved);

    final current = List<News>.from(newsNotifier.value);
    final idx = current.indexWhere((n) => n.id == news.id);
    if (idx != -1) {
      current[idx] = news;
    }
    newsNotifier.value = current;
  }

  /// Update/replace a news item (used by admin edit)
  static Future<void> updateNews(News updated) async {
    final current = List<News>.from(newsNotifier.value);
    final idx = current.indexWhere((n) => n.id == updated.id);
    if (idx != -1) {
      current[idx] = updated;
      await saveAllNews(current);
    }
  }

  /// Get bookmarked items
  static List<News> getBookmarked() {
    return newsNotifier.value.where((n) => n.isBookmarked).toList();
  }
}
