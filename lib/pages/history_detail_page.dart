// pages/history_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/model/scan_history.dart';
import 'package:rubisch/themes/colors.dart';
import 'package:rubisch/pages/item_detail_page.dart';
import 'package:rubisch/data/waste_data.dart'; // Import waste data
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

  // Method to find matching waste category from waste_data.dart
  WasteCategory? _findWasteCategory(String classificationResult) {
    // Normalize the classification result for comparison
    String normalizedResult = classificationResult.toLowerCase().trim();
    
    // Try to find exact match first
    WasteCategory? exactMatch = kWasteCategories.firstWhere(
      (category) => category.title.toLowerCase() == normalizedResult,
      orElse: () => kWasteCategories.first, // fallback to first category
    );
    
    if (exactMatch.title.toLowerCase() == normalizedResult) {
      return exactMatch;
    }
    
    // If no exact match, try partial matches with mapping
    Map<String, String> categoryMapping = {
      'plastik': 'plastic',
      'kertas': 'paper',
      'logam': 'metal',
      'kaca': 'glass',
      'organik': 'biological',
      'elektronik': 'trash', // or create electronics category
      'baterai': 'battery',
      'kardus': 'cardboard',
      'karton': 'cardboard',
      'pakaian': 'clothes',
      'sepatu': 'shoes',
      'makanan': 'biological',
      'organic': 'biological',
      'electronic': 'trash',
    };
    
    // Check if the classification result contains any mapped keywords
    for (String key in categoryMapping.keys) {
      if (normalizedResult.contains(key)) {
        String mappedCategory = categoryMapping[key]!;
        WasteCategory? foundCategory = kWasteCategories.firstWhere(
          (category) => category.title.toLowerCase() == mappedCategory,
          orElse: () => kWasteCategories.first,
        );
        if (foundCategory.title.toLowerCase() == mappedCategory) {
          return foundCategory;
        }
      }
    }
    
    // If still no match found, return the first category as fallback
    return kWasteCategories.first;
  }

  void _navigateToItemDetail() {
    // Find the corresponding waste category from waste_data.dart
    WasteCategory? wasteCategory = _findWasteCategory(_history.classificationResult);
    
    if (wasteCategory != null) {
      // Navigate to ItemDetailPage using data from waste_data.dart
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetailPage(
            title: wasteCategory.title,
            description: wasteCategory.description,
            icon: wasteCategory.icon,
            price: wasteCategory.price, // Use price from waste_data.dart
          ),
        ),
      );
    } else {
      // Fallback navigation if category not found
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemDetailPage(
            title: _history.classificationResult,
            description: 'Informasi detail tentang ${_history.classificationResult}. Item ini dapat didaur ulang untuk membantu lingkungan.',
            icon: Icons.recycling,
            price: _history.price,
          ),
        ),
      );
    }
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
    // Get the waste category for UI display
    WasteCategory? wasteCategory = _findWasteCategory(_history.classificationResult);
    
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

                  // Category Section with icon from waste data
                  _buildDetailRow(
                    icon: wasteCategory?.icon ?? Icons.category,
                    iconColor: AppColors.primary,
                    value: 'Category: ${_history.classificationResult}',
                    textColor: AppColors.dark,
                  ),

                  // Price Section - Show both history price and category base price
                  _buildDetailRow(
                    icon: Icons.monetization_on,
                    iconColor: Colors.green,
                    value: '${_history.price} btc',
                    isBold: false,
                    textColor: AppColors.primary,
                  ),

                  // Base Price from Waste Data (if different from history price)
                  if (wasteCategory != null && wasteCategory.price != _history.price)
                    _buildDetailRow(
                      icon: Icons.info_outline,
                      iconColor: Colors.orange,
                      value: 'Base Price: ${wasteCategory.price} btc',
                      isBold: false,
                      textColor: Colors.orange,
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

          // Enhanced Information Button - Uses waste category data
          GestureDetector(
            onTap: _navigateToItemDetail,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: double.infinity,
              margin: EdgeInsets.all(16.w),
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.neutral,
                border: Border(
                  bottom: BorderSide(color: AppColors.accent, width: 2.w),
                  right: BorderSide(color: AppColors.accent, width: 2.w),
                ),
                borderRadius: BorderRadius.circular(4.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      wasteCategory?.icon ?? Icons.info_outlined,
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
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: AppColors.dark,
                              ),
                            ),
                            TextSpan(
                              text: wasteCategory?.title ?? _history.classificationResult,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                          style: TextStyle(fontSize: 14.sp),
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