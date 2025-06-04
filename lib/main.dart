import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <- tambahkan ini
import 'package:rubisch/pages/main_navigation.dart';
import 'service/history_service.dart'; // Updated import
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive
import 'package:rubisch/utils/coin_manager.dart'; // Import CoinManager
// ... other imports

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive first (safe to call multiple times)
  await Hive.initFlutter(); //

  // Load environment variables FIRST
  await dotenv.load(fileName: ".env"); //

  // Initialize your services
  await HistoryService.init(); //
  await CoinManager().init(); // Initialize the CoinManager

  runApp(MyApp()); //
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const MainNavigation(),
        );
      },
    );
  }
}
