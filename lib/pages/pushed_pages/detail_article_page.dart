import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:rubisch/data/models/article_model.dart';
import 'package:rubisch/themes/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailArticlePage extends StatelessWidget {
  final ArticleModel article;
  const DetailArticlePage({super.key, required this.article});

  String getShortContent(String? content) {
    if (content == null) return "";
    if (content.contains("[")) {
      return content.split("[").first.trim();
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    final defaultImage =
        "https://waste4change.com/blog/wp-content/uploads/image-200.png";

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.neutral,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Detail Article",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
          child: Column(
            spacing: 24.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.light,
                      border: Border.all(color: AppColors.accent, width: 2.w),
                    ),
                    child: Text(
                      article.source!.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.dark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(article.publishedAt!),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Text(
                article.title!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: "Author: ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: article.author ?? "Unknown Author",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  article.urlToImage ?? defaultImage,
                  width: double.infinity,
                  height: 246.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      defaultImage,
                      width: double.infinity,
                      height: 246.h,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Text(getShortContent(article.content)),
              TextButton(
                onPressed: () {
                  launchUrl(Uri.parse(article.url!));
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  minimumSize: Size(double.infinity, 40.h),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: AppColors.primary),
                  ),
                ),
                child: Row(
                  spacing: 4.h,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Read More",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: AppColors.primaryDark,
                      size: 28.sp,
                    ),
                  ],
                ),
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
