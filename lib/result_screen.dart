import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String classificationResult;

  const ResultScreen({Key? key, required this.classificationResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classification Result'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'The detected garbage is: $classificationResult',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}