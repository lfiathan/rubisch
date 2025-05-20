import 'package:flutter/material.dart';
import 'package:rubisch/themes/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Scan Trash',
        elevation: 2.0,
        backgroundColor: AppColors.primary,
        child: Icon(MdiIcons.lineScan, size: 30, color: AppColors.light),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.neutral,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[],
        ),
      ),
    );
  }
}
