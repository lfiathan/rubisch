// lib/data/waste_data.dart
import 'package:flutter/material.dart'; // Import ini karena menggunakan Icons

class WasteCategory {
  final String title;
  final IconData icon;
  final String description;
  final int price; // Gunakan int jika ini harga dasar

  const WasteCategory({
    required this.title,
    required this.icon,
    required this.description,
    required this.price,
  });

  // Metode helper untuk mengonversi menjadi Map jika diperlukan
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon.codePoint, // Simpan codePoint dari IconData
      'description': description,
      'price': price,
    };
  }

  // Metode helper untuk membuat dari Map (jika diambil dari JSON, dll.)
  factory WasteCategory.fromMap(Map<String, dynamic> map) {
    return WasteCategory(
      title: map['title'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'), // Konversi kembali
      description: map['description'] as String,
      price: map['price'] as int,
    );
  }
}

// Daftar statis dari semua kategori sampah
const List<WasteCategory> kWasteCategories = [
  WasteCategory(
    title: 'Plastic',
    icon: Icons.local_drink,
    description:
        'Botol plastik adalah salah satu jenis sampah yang paling umum ditemukan dan dapat didaur ulang dengan efektif. Dengan mendaur ulang botol plastik, kita dapat mengurangi pencemaran lingkungan dan menghemat sumber daya alam.',
    price: 800,
  ),
  WasteCategory(
    title: 'Battery',
    icon: Icons.battery_charging_full,
    description:
        'Baterai bekas mengandung bahan kimia berbahaya yang harus didaur ulang dengan benar. Daur ulang baterai mencegah pencemaran tanah dan air, serta memungkinkan pemulihan logam berharga seperti lithium dan kobalt.',
    price: 1200,
  ),
  WasteCategory(
    title: 'Cardboard',
    icon: Icons.description,
    description:
        'Kardus adalah material kemasan yang sangat mudah didaur ulang. Daur ulang kardus membantu mengurangi penebangan pohon dan menghemat energi dalam proses produksi kemasan baru.',
    price: 300,
  ),
  WasteCategory(
    title: 'Clothes',
    icon: Icons.checkroom,
    description:
        'Pakaian bekas dapat didaur ulang menjadi serat tekstil baru atau produk lainnya. Daur ulang pakaian membantu mengurangi limbah tekstil dan menghemat sumber daya dalam industri fashion.',
    price: 600,
  ),
  WasteCategory(
    title: 'Paper',
    icon: Icons.receipt,
    description:
        'Kertas adalah salah satu material yang paling mudah didaur ulang. Dengan mendaur ulang kertas, kita dapat mengurangi penebangan pohon dan menghemat air serta energi dalam proses produksi.',
    price: 400,
  ),
  WasteCategory(
    title: 'Shoes',
    icon: Icons.ice_skating,
    description:
        'Sepatu bekas dapat didaur ulang dengan memisahkan berbagai komponennya seperti karet sol, kulit, dan tekstil. Daur ulang sepatu membantu mengurangi limbah dan menciptakan produk baru.',
    price: 500,
  ),
  WasteCategory(
    title: 'Glass',
    icon: Icons.local_bar,
    description:
        'Botol kaca dapat didaur ulang tanpa batas tanpa kehilangan kualitas. Daur ulang kaca menghemat energi dan bahan baku, serta mengurangi volume sampah di tempat pembuangan akhir.',
    price: 250,
  ),
  WasteCategory(
    title: 'Metal',
    icon: Icons.iron,
    description:
        'Logam seperti besi, aluminium, dan tembaga dapat didaur ulang berkali-kali tanpa kehilangan kualitas. Daur ulang logam menghemat energi dan mengurangi kebutuhan penambangan bijih baru.',
    price: 1500,
  ),
  WasteCategory(
    title: 'Biological',
    icon: Icons.local_pizza,
    description:
        'Sampah organik seperti sisa makanan dan daun dapat diolah menjadi kompos yang berguna untuk tanaman. Pengomposan membantu mengurangi sampah dan menciptakan pupuk alami.',
    price: 100,
  ),
  WasteCategory(
    title: 'Trash',
    icon: Icons.masks,
    description:
        'Sampah umum yang tidak dapat didaur ulang perlu dikelola dengan baik untuk mengurangi dampak lingkungan. Pengurangan sampah melalui reuse dan reduce adalah langkah terbaik.',
    price: 150,
  ),
];