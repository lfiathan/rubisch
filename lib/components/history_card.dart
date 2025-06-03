// components/history_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/model/scan_history.dart';
import 'package:rubisch/themes/colors.dart';
import 'dart:io';

class HistoryCard extends StatelessWidget {
  final ScanHistory history;

  const HistoryCard({
    super.key,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.neutral,
        border: Border(
          bottom: BorderSide(color: AppColors.accent, width: 2.w),
          right: BorderSide(color: AppColors.accent, width: 2.w),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image Container
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: _buildImageWidget(),
            ),
          ),

          SizedBox(width: 16.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  history.rubbishName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 4.h),

                Text(
                  'Category: ${history.classificationResult}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.dark.withOpacity(0.7),
                  ),
                ),

                SizedBox(height: 4.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${history.price} btc',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      _formatDate(history.timestamp),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.dark.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    if (history.imagePath.isNotEmpty) {
      final file = File(history.imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      }
    }
    
    return Container(
      color: AppColors.primary.withOpacity(0.05),
    );
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final cardDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (cardDate == today) {
      return 'Today';
    } else if (cardDate == yesterday) {
      return 'Yesterday';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}