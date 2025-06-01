// models/scan_history.dart
class ScanHistory {
  final String id;
  final String imagePath;
  final String classificationResult;
  final String rubbishName;
  final int price;
  final DateTime timestamp;

  ScanHistory({
    required this.id,
    required this.imagePath,
    required this.classificationResult,
    required this.rubbishName,
    required this.price,
    required this.timestamp,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'classificationResult': classificationResult,
      'rubbishName': rubbishName,
      'price': price,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  // Create from Map
  factory ScanHistory.fromMap(Map<String, dynamic> map) {
    return ScanHistory(
      id: map['id'] ?? '',
      imagePath: map['imagePath'] ?? '',
      classificationResult: map['classificationResult'] ?? '',
      rubbishName: map['rubbishName'] ?? '',
      price: map['price'] ?? 0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    );
  }
}