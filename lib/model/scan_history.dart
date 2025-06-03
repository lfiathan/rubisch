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

  // Create a copy with some fields changed
  ScanHistory copyWith({
    String? id,
    String? imagePath,
    String? classificationResult,
    String? rubbishName,
    int? price,
    DateTime? timestamp,
  }) {
    return ScanHistory(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      classificationResult: classificationResult ?? this.classificationResult,
      rubbishName: rubbishName ?? this.rubbishName,
      price: price ?? this.price,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScanHistory && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  @override
  String toString() {
    return 'ScanHistory(id: $id, imagePath: $imagePath, classificationResult: $classificationResult, rubbishName: $rubbishName, price: $price, timestamp: $timestamp)';
  }
}