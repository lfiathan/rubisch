import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rubisch/themes/colors.dart';

class CoinInformation extends StatelessWidget {
  final String coin;

  const CoinInformation({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.light,
        border: Border.all(color: AppColors.accent, width: 2.w),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8.w,
          children: [
            Icon(MdiIcons.bitcoin, size: 24.sp, color: AppColors.primary),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Your Coins : ",
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                  TextSpan(
                    text: coin,
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
          ],
        ),
      ),
    );
  }
}
