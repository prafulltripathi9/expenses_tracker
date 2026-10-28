import 'package:expenses_tracker/screen/welcome_screen.dart';
import 'package:expenses_tracker/services/theme_service.dart';
import 'package:flutter/material.dart';

final ThemeService themeService = ThemeService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await themeService.loadTheme();

  runApp(const ExpensesTracker());
}

class ExpensesTracker extends StatelessWidget {
  const ExpensesTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeService,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Personal Expenses',

          themeMode: themeService.themeMode,

          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.light,
            ),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),
          ),

          home: const WelcomeScreen(),
        );
      },
    );
  }
}