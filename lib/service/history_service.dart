// lib/services/history_service.dart

import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart'; // Use Hive
import 'package:rubisch/model/scan_history.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class HistoryService {
  static const String _historyBoxName = 'scan_history_box';
  static const String _historyFolderName = 'rubisch_history';

  // NEW: Initializes Hive and opens the box.
  // This MUST be called in your main.dart file before the app runs.
  static Future<void> init() async {
    // We already initialize Hive.initFlutter() in another service if needed,
    // but it's safe to call it multiple times.
    await Hive.initFlutter();
    Hive.registerAdapter(
      ScanHistoryAdapter(),
    ); // Register the generated adapter
    await Hive.openBox<ScanHistory>(_historyBoxName);
  }

  // This method for saving images is perfect and does not need to change.
  static Future<String> _saveImageToPermanentStorage(
    String tempImagePath,
  ) async {
    // ... no changes needed here ...
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final historyDir = Directory(
        path.join(appDocDir.path, _historyFolderName),
      );
      if (!await historyDir.exists()) {
        await historyDir.create(recursive: true);
      }
      final tempFile = File(tempImagePath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(tempImagePath);
      final fileName = 'scan_${timestamp}$extension';
      final permanentPath = path.join(historyDir.path, fileName);
      await tempFile.copy(permanentPath);
      return permanentPath;
    } catch (e) {
      print('Error saving image: $e');
      return tempImagePath;
    }
  }

  // REFACTORED: Get all history from Hive.
  static List<ScanHistory> getHistory() {
    try {
      final box = Hive.box<ScanHistory>(_historyBoxName);
      final historyList = box.values.toList();
      historyList.sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      ); // Sort by newest first
      return historyList;
    } catch (e) {
      print('Error loading history from Hive: $e');
      return [];
    }
  }

  // REFACTORED: Add new history to Hive and manage the 100-item limit.
  static Future<void> addHistory(ScanHistory history) async {
    try {
      final box = Hive.box<ScanHistory>(_historyBoxName);

      // Add the new item to the box.
      await box.put(history.id, history);

      // --- Your excellent history capping logic, now adapted for Hive ---
      if (box.length > 100) {
        // Get all items sorted by date to find the oldest ones
        final allItems = box.values.toList();
        allItems.sort(
          (a, b) => a.timestamp.compareTo(b.timestamp),
        ); // Sort oldest first

        // Calculate how many items to delete
        final int itemsToDeleteCount = allItems.length - 100;
        final excessItems = allItems.sublist(0, itemsToDeleteCount);

        for (final item in excessItems) {
          // Delete the associated image file
          try {
            final imageFile = File(item.imagePath);
            if (await imageFile.exists()) {
              await imageFile.delete();
            }
          } catch (e) {
            print('Error deleting excess image file: $e');
          }
          // Delete the record from the Hive box
          await box.delete(item.id);
        }
      }
    } catch (e) {
      print('Error adding history to Hive: $e');
      throw Exception('Failed to add history');
    }
  }

  // Wrapper for addHistory. No changes needed.
  static Future<void> saveHistory(ScanHistory history) async {
    await addHistory(history);
  }

  // REFACTORED: Update existing history in Hive.
  static Future<void> updateHistory(ScanHistory updatedHistory) async {
    try {
      final box = Hive.box<ScanHistory>(_historyBoxName);
      // Hive's put command automatically handles updates if the key exists.
      await box.put(updatedHistory.id, updatedHistory);
    } catch (e) {
      print('Error updating history in Hive: $e');
      throw Exception('Failed to update history');
    }
  }

  // REFACTORED: Delete specific history item from Hive.
  static Future<void> deleteHistory(String historyId) async {
    try {
      final box = Hive.box<ScanHistory>(_historyBoxName);

      // First, get the object to find its image path
      final historyToDelete = box.get(historyId);

      if (historyToDelete != null) {
        // Delete the associated image file
        try {
          final imageFile = File(historyToDelete.imagePath);
          if (await imageFile.exists()) {
            await imageFile.delete();
          }
        } catch (e) {
          print('Error deleting image file: $e');
        }

        // Delete the record from the box
        await box.delete(historyId);
      } else {
        throw Exception('History not found in Hive');
      }
    } catch (e) {
      print('Error deleting history from Hive: $e');
      throw Exception('Failed to delete history');
    }
  }

  // This method for creating a ScanHistory object is perfect and does not need to change.
  static Future<ScanHistory> createHistoryFromScan({
    required String tempImagePath,
    required String classificationResult,
    required String rubbishName,
    required int price,
  }) async {
    // ... no changes needed here ...
    final permanentImagePath = await _saveImageToPermanentStorage(
      tempImagePath,
    );
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
