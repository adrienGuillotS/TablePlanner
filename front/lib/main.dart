import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/table_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: TablePlannerApp(),
    ),
  );
}

class TablePlannerApp extends StatelessWidget {
  const TablePlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plan de Table',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TableScreen(),
    );
  }
}