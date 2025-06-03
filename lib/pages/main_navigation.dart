import 'package:flutter/material.dart';
import 'package:rubisch/pages/navbar_pages/history_page.dart';
import 'package:rubisch/pages/navbar_pages/home_page.dart';
import 'package:rubisch/themes/colors.dart';
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

  @override
  void dispose() {
    _mlModelService.dispose();
    super.dispose();
  }

  List<Widget> get _pages => [
    HomePage(
      scrollController: _homeScrollController,
      coinManager: _coinManager,
    ),
    HistoryPage(),
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
