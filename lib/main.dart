import 'package:expenses_tracker/screen/welcome_screen.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(ExpensesTracker());
}
class ExpensesTracker extends StatelessWidget {
  const ExpensesTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Personal Expenses",
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.green),
      ),
      home: const WelcomeScreen(),
    );
  }
}

