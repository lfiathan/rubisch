// pages/history_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/model/scan_history.dart';
import 'package:rubisch/service/history_service.dart';
import 'package:rubisch/themes/colors.dart';
import 'package:rubisch/components/history_card.dart';

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
                        return HistoryCard(history: history);
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
}