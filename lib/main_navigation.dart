import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rubisch/themes/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:rubisch/result_screen.dart';
import 'dart:io';
import 'dart:typed_data';
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

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  void _onItemTapped(int index) {
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

      // Prepare output tensor
      final output = List.filled(
        1 * _labels!.length,
        0.0,
      ).reshape([1, _labels!.length]);

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

  Float32List _imageToByteListFloat32(img.Image image, int inputSize) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (int i = 0; i < inputSize; i++) {
      for (int j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i); // Pixel object in image 4.0.0+

        // Normalize pixel values to [-1, 1]
        buffer[pixelIndex++] = (pixel.r - 127.5) / 127.5;
        buffer[pixelIndex++] = (pixel.g - 127.5) / 127.5;
        buffer[pixelIndex++] = (pixel.b - 127.5) / 127.5;
      }
    }

    return convertedBytes;
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

