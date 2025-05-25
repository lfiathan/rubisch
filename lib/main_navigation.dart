import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rubisch/themes/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:rubisch/result_screen.dart'; // Import the new screen

class MainNavigation extends StatefulWidget {

  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }
  
  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future<void> _scanGarbage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) {
        return; // User cancelled the picker
      }

      await Tflite.loadModel(
        model: "assets/garbage_classifier_model.tflite",
        labels: "assets/labels.txt", // Assuming you have a labels.txt file
        numThreads: 1,
        isAsset: true,
        useGpuDelegate: false,
      );

      final recognitions = await Tflite.runModelOnImage(
        path: pickedFile.path,
        numResults: 1, // Get the top result
        threshold: 0.5, // Confidence threshold
        imageMean: 127.5,
        imageStd: 127.5,
      );

      // Tflite.close(); // Moved to dispose

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(classificationResult: recognitions?.isNotEmpty == true ? recognitions!.first['label'] : 'Unknown'),
        ),
      );
    } catch (e) {
      print("Error scanning garbage: $e");
      // Optionally show an error message to the user
    }
  }


  List<Widget> get _pages => [
    SafeArea(child: Scaffold(body: Center(child: Text("Halaman 1")))),
    SafeArea(child: Scaffold(body: Center(child: Text("Halaman 2")))),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.light,
          body: _pages[_selectedIndex],
          bottomNavigationBar: _buildBottomNavigationBar(),
        ),
        _buildFloatingScanButton(context),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      decoration: BoxDecoration(
        color: AppColors.neutral,
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavIcon(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            index: 0,
          ),
          _buildNavIcon(
            icon: Icons.history_outlined,
            activeIcon: Icons.history,
            index: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon({
    required IconData icon,
    required IconData activeIcon,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: 64.w,
        height: 56.h,
        alignment: Alignment.center,
        child: Icon(
          isSelected ? activeIcon : icon,
          size: 24.sp,
          color: isSelected ? AppColors.primary : AppColors.dark,
        ),
      ),
    );
  }

  Widget _buildFloatingScanButton(BuildContext context) {
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
          onPressed: _scanGarbage,
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
