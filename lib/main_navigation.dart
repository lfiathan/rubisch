import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rubisch/pages/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rubisch/themes/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:rubisch/result_screen.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  Interpreter? _interpreter;
  List<String>? _labels;
  final ScrollController _homeScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  void _onItemTapped(int index) {
    if (index == 0 && _selectedIndex == 0) {
      _homeScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    setState(() => _selectedIndex = index);
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      // Load the model
      _interpreter = await Interpreter.fromAsset(
        'assets/garbage_classifier_model.tflite',
      );

      // Load labels
      final labelsData = await DefaultAssetBundle.of(
        context,
      ).loadString('assets/labels.txt');
      _labels =
          labelsData
              .split('\n')
              .where((label) => label.trim().isNotEmpty)
              .toList();
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> _scanGarbage() async {
    if (_interpreter == null || _labels == null) {
      print("Model not loaded yet");
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile == null) {
        return; // User cancelled the picker
      }

      // Preprocess the image
      final imageFile = File(pickedFile.path);
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        print("Failed to decode image");
        return;
      }

      // Resize image to model input size (assuming 224x224, adjust as needed)
      final resizedImage = img.copyResize(image, width: 224, height: 224);

      // Convert to input tensor format
      final input = _imageToByteListFloat32(resizedImage, 224);

      // Prepare output tensor as 2D list [batch_size, num_classes]
      final output = List.generate(
        1,
        (i) => List<double>.filled(_labels!.length, 0.0),
      );

      // Run inference
      _interpreter!.run(input, output);

      // Get prediction
      final prediction = _getPrediction(output[0]);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResultScreen(
                classificationResult: prediction['label'] ?? 'Unknown',
              ),
        ),
      );
    } catch (e) {
      print("Error scanning garbage: $e");
      // Optionally show an error message to the user
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error scanning image: $e")));
    }
  }

  List<List<List<List<double>>>> _imageToByteListFloat32(
    img.Image image,
    int inputSize,
  ) {
    // Create a 4D list: [batch_size, height, width, channels]
    var input = List.generate(
      1,
      (batch) => List.generate(
        inputSize,
        (y) => List.generate(inputSize, (x) => List<double>.filled(3, 0.0)),
      ),
    );

    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        var pixel = image.getPixel(x, y);

        // Normalize pixel values to [-1, 1] (adjust based on your model's requirements)
        input[0][y][x][0] = (pixel.r - 127.5) / 127.5;
        input[0][y][x][1] = (pixel.g - 127.5) / 127.5;
        input[0][y][x][2] = (pixel.b - 127.5) / 127.5;
      }
    }

    return input;
  }

  Map<String, dynamic> _getPrediction(List<double> output) {
    double maxConfidence = 0.0;
    int maxIndex = 0;

    for (int i = 0; i < output.length; i++) {
      if (output[i] > maxConfidence) {
        maxConfidence = output[i];
        maxIndex = i;
      }
    }

    return {
      'label': maxIndex < _labels!.length ? _labels![maxIndex] : 'Unknown',
      'confidence': maxConfidence,
    };
  }

  List<Widget> get _pages => [
    HomePage(scrollController: _homeScrollController),
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
