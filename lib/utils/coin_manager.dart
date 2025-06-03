// lib/utils/coin_manager.dart
import 'package:flutter/foundation.dart'; // Import ini diperlukan untuk ValueNotifier

class CoinManager {
  // Singleton pattern untuk memastikan hanya ada satu instance CoinManager di seluruh aplikasi
  static final CoinManager _instance = CoinManager._internal();

  factory CoinManager() {
    return _instance;
  }

  CoinManager._internal();

  // ValueNotifier untuk menyimpan saldo koin saat ini.
  // Ini akan memberitahu widget yang mendengarkannya setiap kali nilainya berubah.
  final ValueNotifier<double> _currentCoins = ValueNotifier<double>(0.0); // Koin awal (bisa diubah sesuai kebutuhan)

  // Getter untuk mengakses ValueListenable dari koin saat ini.
  // Widget akan mendengarkan ini untuk memperbarui tampilan koin.
  ValueListenable<double> get currentCoins => _currentCoins;

  // Metode untuk menambahkan koin
  void addCoins(double amount) {
    if (amount > 0) {
      _currentCoins.value += amount; // Tambahkan jumlah koin
      print('Koin ditambahkan: $amount. Total baru: ${_currentCoins.value}');
      // Anda bisa menambahkan logika penyimpanan koin ke Shared Preferences atau database di sini
    }
  }

  // Metode untuk mengatur koin (misalnya, saat memuat dari penyimpanan)
  void setCoins(double amount) {
    _currentCoins.value = amount;
    print('Koin diatur ke: $amount');
  }

  // Anda juga bisa menambahkan metode lain seperti subtractCoins, saveCoinsToStorage, loadCoinsFromStorage, dll.
}