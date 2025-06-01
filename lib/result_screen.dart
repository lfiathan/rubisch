import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/service/history_service.dart';
import 'package:rubisch/themes/colors.dart';
import 'dart:io';

class ResultScreen extends StatefulWidget {
  final String classificationResult;
  final String? imagePath;

  const ResultScreen({
    Key? key,
    required this.classificationResult,
    this.imagePath,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TextEditingController _rubbishNameController = TextEditingController();
  bool _isSaving = false;

  // Data item dengan berbagai kemungkinan nama dari model ML
  static const Map<String, Map<String, dynamic>> _itemsData = {
    // Plastic variants
    'plastic': {
      'icon': Icons.local_drink,
      'description':
          'Botol plastik adalah salah satu jenis sampah yang paling umum ditemukan dan dapat didaur ulang dengan efektif.',
      'price': 800,
    },
    'Plastic': {
      'icon': Icons.local_drink,
      'description':
          'Botol plastik adalah salah satu jenis sampah yang paling umum ditemukan dan dapat didaur ulang dengan efektif.',
      'price': 800,
    },

    // Battery variants
    'battery': {
      'icon': Icons.battery_charging_full,
      'description':
          'Baterai bekas mengandung bahan kimia berbahaya yang harus didaur ulang dengan benar.',
      'price': 1200,
    },
    'Battery': {
      'icon': Icons.battery_charging_full,
      'description':
          'Baterai bekas mengandung bahan kimia berbahaya yang harus didaur ulang dengan benar.',
      'price': 1200,
    },

    // Cardboard variants
    'cardboard': {
      'icon': Icons.description,
      'description':
          'Kardus adalah material kemasan yang sangat mudah didaur ulang.',
      'price': 300,
    },
    'Cardboard': {
      'icon': Icons.description,
      'description':
          'Kardus adalah material kemasan yang sangat mudah didaur ulang.',
      'price': 300,
    },

    // Clothes variants
    'clothes': {
      'icon': Icons.checkroom,
      'description':
          'Pakaian bekas dapat didaur ulang menjadi serat tekstil baru atau produk lainnya.',
      'price': 600,
    },
    'Clothes': {
      'icon': Icons.checkroom,
      'description':
          'Pakaian bekas dapat didaur ulang menjadi serat tekstil baru atau produk lainnya.',
      'price': 600,
    },

    // Paper variants
    'paper': {
      'icon': Icons.receipt,
      'description':
          'Kertas adalah salah satu material yang paling mudah didaur ulang.',
      'price': 400,
    },
    'Paper': {
      'icon': Icons.receipt,
      'description':
          'Kertas adalah salah satu material yang paling mudah didaur ulang.',
      'price': 400,
    },

    // Shoes variants
    'shoes': {
      'icon': Icons.ice_skating,
      'description':
          'Sepatu bekas dapat didaur ulang dengan memisahkan berbagai komponennya.',
      'price': 500,
    },
    'Shoes': {
      'icon': Icons.ice_skating,
      'description':
          'Sepatu bekas dapat didaur ulang dengan memisahkan berbagai komponennya.',
      'price': 500,
    },

    // Glass variants
    'glass': {
      'icon': Icons.local_bar,
      'description':
          'Botol kaca dapat didaur ulang tanpa batas tanpa kehilangan kualitas.',
      'price': 250,
    },
    'Glass': {
      'icon': Icons.local_bar,
      'description':
          'Botol kaca dapat didaur ulang tanpa batas tanpa kehilangan kualitas.',
      'price': 250,
    },

    // Metal variants
    'metal': {
      'icon': Icons.iron,
      'description':
          'Logam dapat didaur ulang berkali-kali tanpa kehilangan kualitas.',
      'price': 1500,
    },
    'Metal': {
      'icon': Icons.iron,
      'description':
          'Logam dapat didaur ulang berkali-kali tanpa kehilangan kualitas.',
      'price': 1500,
    },

    // Biological variants
    'biological': {
      'icon': Icons.local_pizza,
      'description':
          'Sampah organik dapat diolah menjadi kompos yang berguna untuk tanaman.',
      'price': 100,
    },
    'Biological': {
      'icon': Icons.local_pizza,
      'description':
          'Sampah organik dapat diolah menjadi kompos yang berguna untuk tanaman.',
      'price': 100,
    },
    'organic': {
      'icon': Icons.local_pizza,
      'description':
          'Sampah organik dapat diolah menjadi kompos yang berguna untuk tanaman.',
      'price': 100,
    },

    // Trash variants
    'trash': {
      'icon': Icons.masks,
      'description':
          'Sampah umum yang tidak dapat didaur ulang perlu dikelola dengan baik.',
      'price': 150,
    },
    'Trash': {
      'icon': Icons.masks,
      'description':
          'Sampah umum yang tidak dapat didaur ulang perlu dikelola dengan baik.',
      'price': 150,
    },
  };

  @override
  void dispose() {
    _rubbishNameController.dispose();
    super.dispose();
  }

  Future<void> _sellItem() async {
    // Validate if rubbish name is entered
    if (_rubbishNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the rubbish name first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No image to save'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final rubbishName = _rubbishNameController.text.trim();
      final itemData = _getItemData();
      
      // Create and save history
      final history = await HistoryService.createHistoryFromScan(
        tempImagePath: widget.imagePath!,
        classificationResult: widget.classificationResult,
        rubbishName: rubbishName,
        price: itemData['price'],
      );
      
      await HistoryService.saveHistory(history);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Successfully sold "$rubbishName" for ${itemData['price']} btc',
            ),
            backgroundColor: AppColors.primary,
          ),
        );

        // Navigate back to home
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      print('Error saving item: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Map<String, dynamic> _getItemData() {
    // Debug: print the classification result
    print('Classification Result: "${widget.classificationResult}"');

    // Try to find the item data with case-insensitive matching
    Map<String, dynamic>? itemData;

    // First try exact match
    itemData = _itemsData[widget.classificationResult];

    // If not found, try lowercase match
    if (itemData == null) {
      itemData = _itemsData[widget.classificationResult.toLowerCase()];
    }

    // If still not found, try to find partial match
    if (itemData == null) {
      final lowerResult = widget.classificationResult.toLowerCase();
      for (String key in _itemsData.keys) {
        if (key.toLowerCase().contains(lowerResult) ||
            lowerResult.contains(key.toLowerCase())) {
          itemData = _itemsData[key];
          break;
        }
      }
    }

    // Default to trash if nothing found
    itemData ??= _itemsData['trash']!;

    print('Using item data for: ${itemData['price']} btc');
    return itemData;
  }

  @override
  Widget build(BuildContext context) {
    final itemData = _getItemData();

    return Scaffold(
      backgroundColor: AppColors.light,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.light,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Classification Result',
          style: TextStyle(
            color: AppColors.dark,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Main content - Expanded to take remaining space
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

                    // Image Container
                    Center(
                      child: Container(
                        width: 200.w,
                        height: 240.h,
                        decoration: BoxDecoration(
                          color: AppColors.neutral,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: widget.imagePath != null
                              ? Image.file(
                                  File(widget.imagePath!),
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: Icon(
                                    itemData['icon'],
                                    size: 80.sp,
                                    color: AppColors.primary,
                                  ),
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Rubbish Name Input
                    Row(
                      children: [
                        Icon(Icons.delete, color: AppColors.primary, size: 24.sp),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            controller: _rubbishNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter your rubbish name here...',
                              hintStyle: TextStyle(
                                color: AppColors.dark.withOpacity(0.5),
                                fontSize: 16.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              color: AppColors.dark,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Category
                    Row(
                      children: [
                        Icon(Icons.apps, color: AppColors.primary, size: 24.sp),
                        SizedBox(width: 12.w),
                        Text(
                          'Category : ',
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          widget.classificationResult,
                          style: TextStyle(
                            color: AppColors.dark,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Price
                    Row(
                      children: [
                        Icon(Icons.paid, color: AppColors.primary, size: 24.sp),
                        SizedBox(width: 12.w),
                        Text(
                          '${itemData['price']} btc',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    // Add some bottom padding to ensure content doesn't get hidden behind buttons
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Buttons - Fixed at bottom
          Container(
            color: AppColors.light,
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _sellItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.light,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: _isSaving
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.light),
                            ),
                          )
                        : Text(
                            'Sell',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.dark,
                      side: BorderSide(color: AppColors.dark, width: 1.5),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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