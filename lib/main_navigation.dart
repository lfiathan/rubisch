// lib/main_navigation.dart (refactored)
import 'package:flutter/material.dart';
import 'package:rubisch/pages/history_page.dart';
import 'package:rubisch/pages/home_page.dart';
import 'package:rubisch/themes/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:rubisch/result_screen.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:rubisch/utils/coin_manager.dart';
import 'package:rubisch/service/ml_model_service.dart';
import 'package:rubisch/service/scan_service.dart';
import 'package:rubisch/components/custom_navigation_bar.dart';
import 'package:rubisch/components/floating_scan_button.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  final ScrollController _homeScrollController = ScrollController();
  late final CoinManager _coinManager;
  late final MLModelService _mlModelService;
  late final ScanService _scanService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  void _onItemTapped(int index) {
    if (index == 0 && _selectedIndex == 0) {
      _homeScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    setState(() => _selectedIndex = index);
  }

  void _initializeServices() {
    _coinManager = CoinManager();
    _mlModelService = MLModelService();
    _scanService = ScanService(
      mlModelService: _mlModelService,
      coinManager: _coinManager,
    );

    // Load ML model
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadModel();
    });
  }

  Future<void> _loadModel() async {
    try {
      await _mlModelService.loadModel(context);
    } catch (e) {
      print("Failed to load model: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memuat model AI: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void dispose() {
    _mlModelService.dispose();
    super.dispose();
  }

  List<Widget> get _pages => [
    HomePage(scrollController: _homeScrollController, coinManager: _coinManager),
    SafeArea(child: Scaffold(body: Center(child: Text("Halaman 2")))),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.light,
          body: _pages[_selectedIndex],
          bottomNavigationBar: CustomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ),
        FloatingScanButton(onPressed: () => _scanService.scanGarbage(context)),
      ],
    );
  }
}
