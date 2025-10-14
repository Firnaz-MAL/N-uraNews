import 'package:flutter/material.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({Key? key}) : super(key: key);

  Widget _box(double h, [double w = double.infinity]) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Simple skeleton list
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // breaking news skeleton
        _box(180),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return Row(
                children: [
                  _box(80, 120),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _box(16),
                        const SizedBox(height: 8),
                        _box(14),
                        const SizedBox(height: 8),
                        _box(14, 80),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
