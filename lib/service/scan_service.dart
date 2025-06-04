// lib/services/scan_service.dart
import 'package:flutter/material.dart';
import 'package:rubisch/service/camera_service.dart';
import 'package:rubisch/service/ml_model_service.dart';
import 'package:rubisch/pages/pushed_pages/result_page.dart';
import 'package:rubisch/utils/coin_manager.dart';
import 'dart:io';

class ScanService {
  final CameraService _cameraService = CameraService();
  final MLModelService _mlModelService;
  final CoinManager _coinManager;

  ScanService({
    required MLModelService mlModelService,
    required CoinManager coinManager,
  }) : _mlModelService = mlModelService,
       _coinManager = coinManager;

  Future<void> scanGarbage(BuildContext context) async {
    if (!_mlModelService.isModelLoaded) {
      _showErrorSnackBar(context, "Model belum dimuat");
      return;
    }

    try {
      // Take picture
      final File? imageFile = await _cameraService.takePicture();

      if (imageFile == null) {
        return; // User cancelled
      }

      // Show loading indicator
      _showLoadingDialog(context);

      // Classify image
      final prediction = await _mlModelService.classifyImage(imageFile);

      // Hide loading dialog
      Navigator.of(context).pop();

      // Navigate to result screen
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => ResultScreen(
                classificationResult: prediction['label'] ?? 'Unknown',
                imagePath: imageFile.path,
                coinManager: _coinManager,
              ),
        ),
      );
    } catch (e) {
      // Hide loading dialog if showing
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      print("Error scanning garbage: $e");
      _showErrorSnackBar(context, "Error memindai gambar: ${e.toString()}");
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Memproses gambar..."),
            ],
          ),
        );
      },
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
