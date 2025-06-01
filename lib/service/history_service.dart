// services/history_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:rubisch/model/scan_history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class HistoryService {
  static const String _historyKey = 'scan_history';
  static const String _historyFolderName = 'rubisch_history';

  // Get app documents directory for storing images
  static Future<Directory> _getHistoryDirectory() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final historyDir = Directory(path.join(appDocDir.path, _historyFolderName));
    
    if (!await historyDir.exists()) {
      await historyDir.create(recursive: true);
    }
    
    return historyDir;
  }

  // Save image to permanent storage
  static Future<String> _saveImageToPermanentStorage(String tempImagePath) async {
    try {
      final historyDir = await _getHistoryDirectory();
      final tempFile = File(tempImagePath);
      
      // Generate unique filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(tempImagePath);
      final fileName = 'scan_${timestamp}${extension}';
      final permanentPath = path.join(historyDir.path, fileName);
      
      // Copy file to permanent location
      await tempFile.copy(permanentPath);
      
      return permanentPath;
    } catch (e) {
      print('Error saving image: $e');
      return tempImagePath; // Return original path if copy fails
    }
  }

  // Save scan history
  static Future<void> saveHistory(ScanHistory history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing history
      final historyList = await getHistory();
      
      // Add new history to the beginning
      historyList.insert(0, history);
      
      // Keep only last 100 entries to prevent excessive storage
      if (historyList.length > 100) {
        historyList.removeRange(100, historyList.length);
      }
      
      // Convert to JSON string
      final historyJson = historyList.map((h) => h.toMap()).toList();
      final jsonString = jsonEncode(historyJson);
      
      // Save to SharedPreferences
      await prefs.setString(_historyKey, jsonString);
    } catch (e) {
      print('Error saving history: $e');
    }
  }

  // Get all scan history
  static Future<List<ScanHistory>> getHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_historyKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final List<dynamic> historyJson = jsonDecode(jsonString);
      return historyJson.map((json) => ScanHistory.fromMap(json)).toList();
    } catch (e) {
      print('Error loading history: $e');
      return [];
    }
  }

  // Delete specific history item
  static Future<void> deleteHistory(String historyId) async {
    try {
      final historyList = await getHistory();
      
      // Find and remove the item
      final index = historyList.indexWhere((h) => h.id == historyId);
      if (index != -1) {
        final history = historyList[index];
        
        // Delete the image file
        try {
          final imageFile = File(history.imagePath);
          if (await imageFile.exists()) {
            await imageFile.delete();
          }
        } catch (e) {
          print('Error deleting image file: $e');
        }
        
        // Remove from list
        historyList.removeAt(index);
        
        // Save updated list
        final prefs = await SharedPreferences.getInstance();
        final historyJson = historyList.map((h) => h.toMap()).toList();
        final jsonString = jsonEncode(historyJson);
        await prefs.setString(_historyKey, jsonString);
      }
    } catch (e) {
      print('Error deleting history: $e');
    }
  }

  // Clear all history
  static Future<void> clearAllHistory() async {
    try {
      // Delete all image files
      final historyDir = await _getHistoryDirectory();
      if (await historyDir.exists()) {
        await historyDir.delete(recursive: true);
      }
      
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
    } catch (e) {
      print('Error clearing history: $e');
    }
  }

  // Create history from scan result
  static Future<ScanHistory> createHistoryFromScan({
    required String tempImagePath,
    required String classificationResult,
    required String rubbishName,
    required int price,
  }) async {
    // Save image to permanent storage
    final permanentImagePath = await _saveImageToPermanentStorage(tempImagePath);
    
    return ScanHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: permanentImagePath,
      classificationResult: classificationResult,
      rubbishName: rubbishName,
      price: price,
      timestamp: DateTime.now(),
    );
  }
}