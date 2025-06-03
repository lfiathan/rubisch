// lib/services/ml_model_service.dart
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:io';

class MLModelService {
  Interpreter? _interpreter;
  List<String>? _labels;

  bool get isModelLoaded => _interpreter != null && _labels != null;

  Future<void> loadModel(BuildContext context) async {
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

      print("Model loaded successfully with ${_labels?.length} labels");
    } catch (e) {
      print("Error loading model: $e");
      throw Exception("Failed to load ML model: $e");
    }
  }

  Future<Map<String, dynamic>> classifyImage(File imageFile) async {
    if (!isModelLoaded) {
      throw Exception("Model not loaded");
    }

    try {
      // Preprocess the image
      final imageBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(imageBytes);

      if (image == null) {
        throw Exception("Failed to decode image");
      }

      // Resize image to model input size (assuming 224x224)
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

      print(
        'ML Prediction: ${prediction['label']} with confidence: ${prediction['confidence']}',
      );

      return prediction;
    } catch (e) {
      print("Error classifying image: $e");
      throw Exception("Failed to classify image: $e");
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
      'index': maxIndex,
    };
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _labels = null;
  }
}
