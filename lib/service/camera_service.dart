// lib/services/camera_service.dart
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> takePicture() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Optimize image quality for processing
      );

      if (pickedFile == null) {
        return null; // User cancelled
      }

      return File(pickedFile.path);
    } catch (e) {
      print("Error taking picture: $e");
      throw Exception("Failed to take picture: $e");
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return null; // User cancelled
      }

      return File(pickedFile.path);
    } catch (e) {
      print("Error picking image: $e");
      throw Exception("Failed to pick image: $e");
    }
  }
}
