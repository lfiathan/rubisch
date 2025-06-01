import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/components/carousel.dart';
import 'package:rubisch/components/coin_information.dart';
import 'package:rubisch/components/item_information.dart';
import 'package:rubisch/pages/item_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> _items = const [
    {
      'icon': Icons.local_drink,
      'title': 'Plastic',
      'description':
          'Botol plastik adalah salah satu jenis sampah yang paling umum ditemukan dan dapat didaur ulang dengan efektif. Dengan mendaur ulang botol plastik, kita dapat mengurangi pencemaran lingkungan dan menghemat sumber daya alam.',
      'price': 800,
    },
    {
      'icon': Icons.battery_charging_full,
      'title': 'Battery',
      'description':
          'Baterai bekas mengandung bahan kimia berbahaya yang harus didaur ulang dengan benar. Daur ulang baterai mencegah pencemaran tanah dan air, serta memungkinkan pemulihan logam berharga seperti lithium dan kobalt.',
      'price': 1200,
    },
    {
      'icon': Icons.description,
      'title': 'Cardboard',
      'description':
          'Kardus adalah material kemasan yang sangat mudah didaur ulang. Daur ulang kardus membantu mengurangi penebangan pohon dan menghemat energi dalam proses produksi kemasan baru.',
      'price': 300,
    },
    {
      'icon': Icons.checkroom,
      'title': 'Clothes',
      'description':
          'Pakaian bekas dapat didaur ulang menjadi serat tekstil baru atau produk lainnya. Daur ulang pakaian membantu mengurangi limbah tekstil dan menghemat sumber daya dalam industri fashion.',
      'price': 600,
    },
    {
      'icon': Icons.receipt,
      'title': 'Paper',
      'description':
          'Kertas adalah salah satu material yang paling mudah didaur ulang. Dengan mendaur ulang kertas, kita dapat mengurangi penebangan pohon dan menghemat air serta energi dalam proses produksi.',
      'price': 400,
    },
    {
      'icon': Icons.ice_skating,
      'title': 'Shoes',
      'description':
          'Sepatu bekas dapat didaur ulang dengan memisahkan berbagai komponennya seperti karet sol, kulit, dan tekstil. Daur ulang sepatu membantu mengurangi limbah dan menciptakan produk baru.',
      'price': 500,
    },
    {
      'icon': Icons.local_bar,
      'title': 'Glass',
      'description':
          'Botol kaca dapat didaur ulang tanpa batas tanpa kehilangan kualitas. Daur ulang kaca menghemat energi dan bahan baku, serta mengurangi volume sampah di tempat pembuangan akhir.',
      'price': 250,
    },
    {
      'icon': Icons.iron,
      'title': 'Metal',
      'description':
          'Logam seperti besi, aluminium, dan tembaga dapat didaur ulang berkali-kali tanpa kehilangan kualitas. Daur ulang logam menghemat energi dan mengurangi kebutuhan penambangan bijih baru.',
      'price': 1500,
    },
    {
      'icon': Icons.local_pizza,
      'title': 'Biological',
      'description':
          'Sampah organik seperti sisa makanan dan daun dapat diolah menjadi kompos yang berguna untuk tanaman. Pengomposan membantu mengurangi sampah dan menciptakan pupuk alami.',
      'price': 100,
    },
    {
      'icon': Icons.masks,
      'title': 'Trash',
      'description':
          'Sampah umum yang tidak dapat didaur ulang perlu dikelola dengan baik untuk mengurangi dampak lingkungan. Pengurangan sampah melalui reuse dan reduce adalah langkah terbaik.',
      'price': 150,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 32.h,
          children: [
            SizedBox(),
            Column(
              spacing: 8.h,
              children: [
                Text(
                  "Hello User !",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Let's turn waste into value!",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            Column(
              spacing: 16.h,
              children: [
                CarouselWidget(
                  imageUrls: [
                    'https://penjagalaut.org/wp-content/uploads/2023/01/2-1015x675.png',
                    'https://yiari.or.id/wp-content/uploads/2025/01/daur.webp',
                    'https://pict.sindonews.net/dyn/732/pena/news/2020/05/14/45/28828/inilah-10-negara-terbaik-pendaur-ulang-sampah-kvf.jpg',
                  ],
                ),
                CoinInformation(coin: "1200"),

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
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return ItemInformation(
                          icon: item['icon'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ItemDetailPage(
                                      title: item['title'],
                                      description: item['description'],
                                      icon: item['icon'],
                                      price: item['price'],
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
