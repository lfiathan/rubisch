// lib/utils/coin_manager.dart
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive

class CoinManager {
  static final CoinManager _instance = CoinManager._internal();

  factory CoinManager() {
    return _instance;
  }

  CoinManager._internal();

  // --- HIVE INTEGRATION ---
  static const String _appStateBoxName = 'app_state_box';
  static const String _coinsKey = 'current_coins';

  // Late initialization for the Hive box
  late final Box _box;

  // NEW: An init() method to set up the box and load data
  // This must be called in main.dart before the app runs.
  Future<void> init() async {
    // The box might already be opened by another service, which is fine.
    // If not, this will open it.
    _box = await Hive.openBox(_appStateBoxName);

    // Load the saved coin value from Hive. Default to 0.0 if not found.
    final double savedCoins = _box.get(_coinsKey, defaultValue: 0.0) as double;
    _currentCoins.value = savedCoins;
    print('CoinManager initialized. Loaded coins: $savedCoins');
  }
  // --- END HIVE INTEGRATION ---

  final ValueNotifier<double> _currentCoins = ValueNotifier<double>(0.0);

  ValueListenable<double> get currentCoins => _currentCoins;

  // MODIFIED: addCoins now saves to Hive
  Future<void> addCoins(double amount) async {
    if (amount > 0) {
      _currentCoins.value += amount;
      await _saveCoinsToStorage(); // Save the new value
      print('Coins added: $amount. New total: ${_currentCoins.value}');
    }
  }

  // MODIFIED: setCoins now saves to Hive
  Future<void> setCoins(double amount) async {
    _currentCoins.value = amount;
    await _saveCoinsToStorage(); // Save the new value
    print('Coins set to: $amount');
  }

  // NEW: A method for subtracting coins
  Future<void> subtractCoins(double amount) async {
    if (amount > 0 && _currentCoins.value >= amount) {
      _currentCoins.value -= amount;
      await _saveCoinsToStorage(); // Save the new value
      print('Coins subtracted: $amount. New total: ${_currentCoins.value}');
    } else {
      print('Cannot subtract coins: insufficient balance or invalid amount.');
    }
  }

  // NEW: Private helper method to save the current value to Hive
  Future<void> _saveCoinsToStorage() async {
    await _box.put(_coinsKey, _currentCoins.value);
  }
}
