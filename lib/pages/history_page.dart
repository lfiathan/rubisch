// pages/history_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/model/scan_history.dart';
import 'package:rubisch/service/history_service.dart';
import 'package:rubisch/themes/colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<ScanHistory> _historyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final history = await HistoryService.getHistory();
      if (mounted) {
        setState(() {
          _historyList = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading history: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      body: SafeArea(
        child: _isLoading
            ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
            : _historyList.isEmpty
            ? _buildEmptyState()
            : RefreshIndicator(
              onRefresh: _loadHistory,
              color: AppColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // History Title
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      'History',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  // History List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: _historyList.length,
                      itemBuilder: (context, index) {
                        final history = _historyList[index];
                        return _buildHistoryCard(history);
                      },
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80.sp,
            color: AppColors.dark.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'No history yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.dark.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start scanning items to see your history here',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.dark.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(ScanHistory history) {
    // Function to get icon based on category
    IconData _getCategoryIcon(String category) {
      switch (category.toLowerCase()) {
        case 'plastic':
          return Icons.water_drop_outlined;
        case 'paper':
          return Icons.description_outlined;
        case 'metal':
          return Icons.hardware_outlined;
        case 'glass':
          return Icons.local_drink_outlined;
        case 'organic':
          return Icons.eco_outlined;
        case 'electronic':
          return Icons.electrical_services_outlined;
        default:
          return Icons.delete_outline;
      }
    }

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
          // Category Icon
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: Icon(
              _getCategoryIcon(history.classificationResult),
              size: 40.sp,
              color: AppColors.primary,
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
}