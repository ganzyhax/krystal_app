import 'package:flutter/material.dart';
import 'package:sauna_krystal/app/screens/home/home_screen.dart';

class SaunaKrystalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sauna Krystal',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
