// pages/history_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/model/scan_history.dart';
import 'package:rubisch/themes/colors.dart';
import 'package:rubisch/pages/item_detail_page.dart';
import 'dart:io';

class HistoryDetailPage extends StatefulWidget {
  final ScanHistory history;
  final Function(ScanHistory)? onUpdate;
  final Function(String)? onDelete;

  const HistoryDetailPage({
    super.key, 
    required this.history,
    this.onUpdate,
    this.onDelete,
  });

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  late ScanHistory _history;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _history = widget.history;
    _nameController.text = _history.rubbishName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dateTime) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${dateTime.day.toString().padLeft(2, '0')} ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  void _navigateToItemDetail() {
    // Navigate to ItemDetailPage using existing data from history
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailPage(
          title: _history.rubbishName,
          description: 'Detailed information about ${_history.classificationResult}', // You can customize this or get from existing data source
          icon: Icons.recycling, // You can map this based on classification if needed
          price: _history.price,
        ),
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Name',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.dark,
            ),
          ),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter item name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.dark.withOpacity(0.7)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _history = ScanHistory(
                    id: _history.id,
                    rubbishName: _nameController.text,
                    classificationResult: _history.classificationResult,
                    price: _history.price,
                    timestamp: _history.timestamp,
                    imagePath: _history.imagePath,
                  );
                });
                Navigator.pop(context);
                
                // Call the update callback if provided
                if (widget.onUpdate != null) {
                  widget.onUpdate!(_history);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete History',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.dark,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this history item?',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.dark.withOpacity(0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.dark.withOpacity(0.7)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to history page
                
                // Call the delete callback if provided
                if (widget.onDelete != null) {
                  widget.onDelete!(_history.id);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: AppBar(
        backgroundColor: AppColors.light,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: AppColors.dark),
        ),
        title: Text(
          'History Detail',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showEditDialog,
            icon: Icon(Icons.edit, color: AppColors.primary),
          ),
          IconButton(
            onPressed: _showDeleteDialog,
            icon: Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      body: Column(
        children: [
          // Main content with scroll
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 200.w,
                          height: 240.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: AppColors.primary.withOpacity(0.1),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: _buildImageWidget(),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          _history.rubbishName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.dark,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Category Section
                  _buildDetailRow(
                    icon: Icons.category,
                    iconColor: AppColors.primary,
                    value: 'Category: ${_history.classificationResult}',
                    textColor: AppColors.dark,
                  ),

                  // Price Section
                  _buildDetailRow(
                    icon: Icons.monetization_on,
                    iconColor: Colors.green,
                    value: '${_history.price} btc',
                    isBold: false,
                    textColor: AppColors.primary,
                  ),

                  // Date Section
                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    iconColor: AppColors.primary,
                    value: _formatDate(_history.timestamp),
                    isBold: false,
                  ),
                ],
              ),
            ),
          ),

          // Information Button - Fixed at bottom (Now clickable)
          GestureDetector(
            onTap: _navigateToItemDetail,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(16.w),
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.neutral,
                border: Border(
                  bottom: BorderSide(color: AppColors.accent, width: 2.w),
                  right: BorderSide(color: AppColors.accent, width: 2.w),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 24.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Information about ",
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            TextSpan(
                              text: _history.classificationResult,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget() {
    if (_history.imagePath.isNotEmpty) {
      final file = File(_history.imagePath);
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
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          size: 80.sp,
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String value,
    bool isBold = true,
    Color? textColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: textColor ?? AppColors.dark,
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}