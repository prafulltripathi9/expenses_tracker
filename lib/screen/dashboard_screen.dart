import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F2E8),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [
                  Column(
                    children: [
                      Text("Hello, Welcome", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF064E3B) ),),
                      SizedBox(height: 6,),
                      Text("Let's track your money", style: TextStyle(fontSize:14,color: Color(0xFF374151)),),
                    ],
                  ),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.settings_outlined, color: Color(0xFF064E3B), size: 28,)),
                  SizedBox(height: 28,),
                ],
            ),
        ],),
      )),
    );  
  }
}