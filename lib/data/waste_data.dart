// lib/data/waste_data.dart
import 'package:flutter/material.dart';

class WasteCategory {
  final String title;
  final IconData icon;
  final String description;
  final int price;

  const WasteCategory({
    required this.title,
    required this.icon,
    required this.description,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon.codePoint,
      'description': description,
      'price': price,
    };
  }

  factory WasteCategory.fromMap(Map<String, dynamic> map) {
    return WasteCategory(
      title: map['title'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
      description: map['description'] as String,
      price: map['price'] as int,
    );
  }
}

const List<WasteCategory> kWasteCategories = [
  WasteCategory(
    title: 'Plastic',
    icon: Icons.local_drink,
    description:
        'Plastic bottles are one of the most common types of waste and can be effectively recycled. Recycling plastic bottles helps reduce environmental pollution and conserve natural resources.',
    price: 800,
  ),
  WasteCategory(
    title: 'Battery',
    icon: Icons.battery_charging_full,
    description:
        'Used batteries contain harmful chemicals that must be properly recycled. Battery recycling prevents soil and water contamination and allows the recovery of valuable metals like lithium and cobalt.',
    price: 1200,
  ),
  WasteCategory(
    title: 'Cardboard',
    icon: Icons.description,
    description:
        'Cardboard is a packaging material that is very easy to recycle. Recycling cardboard helps reduce deforestation and saves energy in the production of new packaging.',
    price: 300,
  ),
  WasteCategory(
    title: 'Clothes',
    icon: Icons.checkroom,
    description:
        'Used clothes can be recycled into new textile fibers or other products. Clothing recycling helps reduce textile waste and conserves resources in the fashion industry.',
    price: 600,
  ),
  WasteCategory(
    title: 'Paper',
    icon: Icons.receipt,
    description:
        'Paper is one of the easiest materials to recycle. Recycling paper reduces deforestation and saves water and energy in the production process.',
    price: 400,
  ),
  WasteCategory(
    title: 'Shoes',
    icon: Icons.ice_skating,
    description:
        'Used shoes can be recycled by separating their components such as rubber soles, leather, and textiles. Recycling shoes helps reduce waste and create new products.',
    price: 500,
  ),
  WasteCategory(
    title: 'Glass',
    icon: Icons.local_bar,
    description:
        'Glass bottles can be endlessly recycled without losing quality. Recycling glass saves energy and raw materials, and reduces landfill waste volume.',
    price: 250,
  ),
  WasteCategory(
    title: 'Metal',
    icon: Icons.iron,
    description:
        'Metals like iron, aluminum, and copper can be recycled many times without quality loss. Metal recycling saves energy and reduces the need for new ore mining.',
    price: 1500,
  ),
  WasteCategory(
    title: 'Biological',
    icon: Icons.local_pizza,
    description:
        'Organic waste such as food scraps and leaves can be composted into useful fertilizer for plants. Composting helps reduce waste and creates natural fertilizer.',
    price: 100,
  ),
  WasteCategory(
    title: 'Trash',
    icon: Icons.masks,
    description:
        'General waste that cannot be recycled needs to be properly managed to minimize environmental impact. Waste reduction through reuse and reduce is the best approach.',
    price: 150,
  ),
];
