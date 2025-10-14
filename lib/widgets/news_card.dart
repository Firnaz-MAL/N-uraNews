import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/news.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final VoidCallback? onTap;
  final VoidCallback? onBookmarkToggle;

  const NewsCard({
    Key? key,
    required this.news,
    this.onTap,
    this.onBookmarkToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBookmarked = news.isBookmarked;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10.r,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Gambar berita
            ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Image.network(
                news.imageUrl,
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 120.w,
                  height: 100.h,
                  color: Colors.white.withOpacity(0.15),
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.white70),
                ),
              ),
            ),
            SizedBox(width: 14.w),

            // 📰 Konten berita
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Deskripsi
                  Text(
                    news.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Footer waktu + bookmark
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '2 jam lalu',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12.sp,
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(30.r),
                        onTap: onBookmarkToggle,
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: isBookmarked
                                ? Colors.amberAccent
                                : Colors.white.withOpacity(0.9),
                            size: 22.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
