// lib/widgets/floating_scan_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rubisch/themes/colors.dart';

class FloatingScanButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FloatingScanButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16.h,
      left: MediaQuery.of(context).size.width / 2 - 28.w,
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: FloatingActionButton(
          onPressed: onPressed,
          tooltip: 'Scan Trash',
          elevation: 2.0,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: AppColors.neutral, width: 4.w),
          ),
          child: Icon(MdiIcons.lineScan, size: 24.sp, color: AppColors.light),
        ),
      ),
    );
  }
}
