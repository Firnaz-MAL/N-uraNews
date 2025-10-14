import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/local_storage.dart';
import '../models/news.dart';

class ProfileScreen extends StatefulWidget {
  final String userName;

  const ProfileScreen({super.key, required this.userName});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  List<News> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();

    LocalStorage.newsNotifier.addListener(_reloadBookmarks);
    _reloadBookmarks();
  }

  void _reloadBookmarks() {
    setState(() {
      bookmarks = LocalStorage.getBookmarked();
    });
  }

  @override
  void dispose() {
    LocalStorage.newsNotifier.removeListener(_reloadBookmarks);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = '${widget.userName.toLowerCase()}@example.com';
    final avatarUrl =
        'https://api.dicebear.com/9.x/avataaars/svg?seed=${widget.userName}';

    // ambil topik dari judul/sumber bookmark (bisa ubah jadi kategori kalau ada)
    final likedTopics = bookmarks
        .map((b) => b.source)
        .toSet()
        .take(3)
        .join(', ');

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D83F2), Color(0xFF8E54E9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Profil Saya',
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.settings, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                      CircleAvatar(
                        radius: 55.r,
                        backgroundImage: NetworkImage(avatarUrl),
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        widget.userName,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        email,
                        style: TextStyle(color: Colors.white70, fontSize: 16.sp),
                      ),
                      SizedBox(height: 40.h),
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          children: [
                            _infoTile(
                              Icons.bookmark,
                              'Artikel Tersimpan',
                              '${bookmarks.length} Berita',
                            ),
                            const Divider(color: Colors.white30),

                            // hanya tampil kalau ada topik yang disukai
                            if (likedTopics.isNotEmpty) ...[
                              _infoTile(
                                Icons.favorite,
                                'Disukai',
                                likedTopics,
                              ),
                              const Divider(color: Colors.white30),
                            ],

                            _infoTile(
                              Icons.history,
                              'Riwayat Bacaan',
                              '28 berita terakhir',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF6D83F2),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/splash');
                          },
                          child: Text(
                            'Keluar Akun',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 30.sp),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white70, fontSize: 14.sp),
      ),
    );
  }
}
