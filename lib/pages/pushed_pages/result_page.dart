// lib/result_screen.dart (modifikasi)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/service/history_service.dart';
import 'package:rubisch/themes/colors.dart';
import 'dart:io';
import 'package:rubisch/utils/coin_manager.dart';
import 'package:rubisch/data/waste_data.dart'; // Import data pusat

class ResultScreen extends StatefulWidget {
  final String classificationResult;
  final String? imagePath;
  final CoinManager coinManager;

  const ResultScreen({
    super.key,
    required this.classificationResult,
    this.imagePath,
    required this.coinManager,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TextEditingController _rubbishNameController = TextEditingController();
  bool _isSaving = false;

  // Buat Map dari kWasteCategories untuk pencarian yang efisien berdasarkan title (huruf kecil)
  // Ini akan dibuat sekali saat state diinisialisasi
  late final Map<String, WasteCategory> _wasteCategoriesMap;

  @override
  void initState() {
    super.initState();
    // Inisialisasi map saat initState
    _wasteCategoriesMap = {
      for (var category in kWasteCategories)
        category.title.toLowerCase(): category,
    };
  }

  @override
  void dispose() {
    _rubbishNameController.dispose();
    super.dispose();
  }

  Future<void> _sellItem() async {
    if (_rubbishNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon masukkan nama sampah terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tidak ada gambar untuk disimpan'),
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
      final WasteCategory selectedCategory =
          _getWasteCategory(); // Gunakan objek WasteCategory
      final int price = selectedCategory.price;

      final history = await HistoryService.createHistoryFromScan(
        tempImagePath: widget.imagePath!,
        classificationResult:
            widget
                .classificationResult, // Tetap gunakan hasil asli untuk riwayat
        rubbishName: rubbishName,
        price: price,
      );

      await HistoryService.saveHistory(history);

      widget.coinManager.addCoins(
        price.toDouble(),
      ); // Pastikan ini double jika CoinManager mengharapkan double

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Berhasil menjual "$rubbishName" seharga ${price} btc. Saldo baru: ${widget.coinManager.currentCoins.value.toInt()} btc',
            ),
            backgroundColor: AppColors.primary,
          ),
        );

        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      print('Error menyimpan item: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error menyimpan item: $e'),
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

  // Mengubah _getItemData menjadi _getWasteCategory
  WasteCategory _getWasteCategory() {
    print('Classification Result: "${widget.classificationResult}"');

    final normalizedClassification = widget.classificationResult.toLowerCase();

    // Coba pencocokan tepat menggunakan map
    WasteCategory? category = _wasteCategoriesMap[normalizedClassification];

    // Fallback untuk pencocokan parsial jika klasifikasi tidak tepat sama dengan kunci map
    // Ini mungkin tidak diperlukan jika ML selalu menghasilkan nama yang cocok dengan salah satu kategori
    if (category == null) {
      for (var entry in _wasteCategoriesMap.entries) {
        if (normalizedClassification.contains(entry.key) ||
            entry.key.contains(normalizedClassification)) {
          category = entry.value;
          break;
        }
      }
    }

    // Default ke 'Trash' jika tidak ada yang cocok
    category ??=
        _wasteCategoriesMap['trash']!; // Pastikan 'trash' selalu ada di map Anda

    print(
      'Menggunakan kategori: ${category.title} dengan harga ${category.price} btc',
    );
    return category;
  }

  @override
  Widget build(BuildContext context) {
    final WasteCategory currentCategory = _getWasteCategory();

    return Scaffold(
      backgroundColor: AppColors.light,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.light,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Classification Result",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.dark,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),

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
                          child:
                              widget.imagePath != null
                                  ? Image.file(
                                    File(widget.imagePath!),
                                    fit: BoxFit.cover,
                                  )
                                  : Container(
                                    color: Colors.grey[300],
                                    child: Icon(
                                      currentCategory
                                          .icon, // Akses icon dari objek
                                      size: 80.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    Row(
                      children: [
                        Icon(
                          Icons.delete,
                          color: AppColors.primary,
                          size: 24.sp,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            controller: _rubbishNameController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan nama sampah Anda di sini...',
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

                    Row(
                      children: [
                        Icon(Icons.apps, color: AppColors.primary, size: 24.sp),
                        SizedBox(width: 12.w),
                        Text(
                          'Kategori : ',
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

                    Row(
                      children: [
                        Icon(Icons.paid, color: AppColors.primary, size: 24.sp),
                        SizedBox(width: 12.w),
                        Text(
                          '${currentCategory.price} btc', // Akses price dari objek
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ),

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
                    child:
                        _isSaving
                            ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.light,
                                ),
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
