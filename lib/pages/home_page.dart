// lib/pages/home_page.dart (modifikasi)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/components/carousel.dart';
import 'package:rubisch/components/coin_information.dart';
import 'package:rubisch/components/item_information.dart';
import 'package:rubisch/pages/item_detail_page.dart';
import 'package:rubisch/utils/coin_manager.dart';
import 'package:rubisch/data/waste_data.dart'; // Import data pusat

class HomePage extends StatelessWidget {
  final CoinManager coinManager;

  const HomePage({super.key, required this.coinManager});

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

            Column(
              children: [
                CarouselWidget(
                  imageUrls: [
                    'https://penjagalaut.org/wp-content/uploads/2023/01/2-1015x675.png',
                    'https://yiari.or.id/wp-content/uploads/2025/01/daur.webp',
                    'https://pict.sindonews.net/dyn/732/pena/news/2020/05/14/45/28828/inilah-10-negara-terbaik-pendaur-ulang-sampah-kvf.jpg',
                  ],
                ),
                SizedBox(height: 16.h),

                ValueListenableBuilder<double>(
                  valueListenable: coinManager.currentCoins,
                  builder: (context, currentCoins, child) {
                    return CoinInformation(
                      coin: currentCoins.toInt().toString(),
                    );
                  },
                ),

                SizedBox(height: 16.h),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Information",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        childAspectRatio: 1,
                      ),
                      // Gunakan kWasteCategories
                      itemCount: kWasteCategories.length,
                      itemBuilder: (context, index) {
                        final item = kWasteCategories[index]; // Ambil dari data pusat
                        return ItemInformation(
                          icon: item.icon, // Akses properti objek WasteCategory
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemDetailPage(
                                  title: item.title,
                                  description: item.description,
                                  icon: item.icon,
                                  price: item.price,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}