import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rubisch/components/article_card.dart';
import 'package:rubisch/components/carousel.dart';
import 'package:rubisch/components/coin_information.dart';
import 'package:rubisch/data/api/article_api.dart';
import 'package:rubisch/data/models/article_response.dart';
import 'package:rubisch/themes/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<ArticleResponse> article = ArticleApi().topHeadlines();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 32.h,
            children: [
              SizedBox(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                ],
              ),

              Column(
                spacing: 16.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8.w,
                    children: [
                      Icon(
                        MdiIcons.newspaper,
                        size: 28.sp,
                        color: AppColors.primary,
                      ),
                      Text(
                        "Latest News",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<ArticleResponse>(
                    future: article,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData) {
                        final articles = snapshot.data!.articles;
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: ArticleCard(
                                article: articles[index],
                                onTap: () => {print("BISA COYY")},
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else {
                        return Center(child: Text("No data found"));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
