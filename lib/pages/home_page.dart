import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/components/carousel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.h),
            Column(
              children: [
                Text(
                  "Hello User !",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Let's turn waste into value!",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            SizedBox(height: 32.h),
            CarouselWidget(
              imageUrls: [
                'https://penjagalaut.org/wp-content/uploads/2023/01/2-1015x675.png',
                'https://yiari.or.id/wp-content/uploads/2025/01/daur.webp',
                'https://pict.sindonews.net/dyn/732/pena/news/2020/05/14/45/28828/inilah-10-negara-terbaik-pendaur-ulang-sampah-kvf.jpg',
              ],
            ),
          ],
        ),
      ),
    );
  }
}
