// pages/item_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/themes/colors.dart';

class ItemDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final int price;

  const ItemDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.price,
  });

  // Function to get image URL based on item title
  String _getImageUrl(String itemTitle) {
    String searchTerm = itemTitle.toLowerCase();

    // Map common waste items to appropriate search terms
    if (searchTerm.contains('botol')) {
      if (searchTerm.contains('plastik')) {
        return 'https://images.unsplash.com/photo-1572879435734-80d7556eb8c7?w=400&h=300&fit=crop';
      } else {
        return 'https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?w=400&h=300&fit=crop';
      }
    } else if (searchTerm.contains('kaleng')) {
      return 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=400&h=300&fit=crop';
    } else if (searchTerm.contains('kardus') || searchTerm.contains('karton')) {
      return 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=400&h=300&fit=crop';
    } else if (searchTerm.contains('kertas')) {
      return 'https://images.unsplash.com/photo-1586075010923-2dd4570fb338?w=400&h=300&fit=crop';
    } else if (searchTerm.contains('kaca')) {
      return 'https://images.unsplash.com/photo-1594736797933-d0401ba2fe65?w=400&h=300&fit=crop';
    } else if (searchTerm.contains('elektronik') ||
        searchTerm.contains('gadget')) {
      return 'https://images.unsplash.com/photo-1551698618-1dfe5d97d256?w=400&h=300&fit=crop';
    } else if (searchTerm.contains('baterai')) {
      return 'https://images.unsplash.com/photo-1609592806131-9fb8eb5d4d3c?w=400&h=300&fit=crop';
    } else if (searchTerm.contains('organik') ||
        searchTerm.contains('sisa makanan')) {
      return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&h=300&fit=crop';
    } else {
      // Default waste/recycling image
      return 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=400&h=300&fit=crop';
    }
  }

  @override
  Widget build(BuildContext context) {
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
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Image.network(
                  _getImageUrl(title),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to icon if image fails to load
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 50.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2.w,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Price Information Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.light,
                border: Border.all(color: AppColors.accent, width: 2.w),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Harga : ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: price.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      TextSpan(
                        text: " btc",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Description Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.light,
                border: Border.all(color: AppColors.accent, width: 2.w),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Deskripsi",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.dark.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
