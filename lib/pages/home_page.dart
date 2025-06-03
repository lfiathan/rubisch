import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/components/article_card.dart';
import 'package:rubisch/components/carousel.dart';
import 'package:rubisch/components/coin_information.dart';
import 'package:rubisch/data/api/article_api.dart';
import 'package:rubisch/data/models/article_response.dart';
import 'package:rubisch/themes/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<ArticleResponse> article = ArticleApi().topHeadlines();
  int shownArticleCount = 10;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SingleChildScrollView(
          child: Column(
            spacing: 28.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              Column(
                spacing: 8.h,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                spacing: 12.h,
                children: [
                  Row(
                    spacing: 8.w,
                    children: [
                      Icon(
                        Icons.article,
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
                        final allArticles = snapshot.data!.articles;
                        final maxToShow = shownArticleCount.clamp(
                          0,
                          allArticles.length,
                        );
                        final articlesToShow =
                            allArticles.take(maxToShow).toList();

                        return Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: articlesToShow.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: ArticleCard(
                                    article: articlesToShow[index],
                                    onTap: () => {},
                                  ),
                                );
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  shownArticleCount += 10;
                                });
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                minimumSize: Size(double.infinity, 40.h),
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                  side: BorderSide(color: AppColors.primary),
                                ),
                              ),
                              child: Row(
                                spacing: 4.h,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.primary,
                                    size: 28.sp,
                                  ),
                                  Text(
                                    "Show More",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
