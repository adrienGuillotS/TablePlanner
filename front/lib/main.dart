import 'package:flutter/material.dart';
import 'screens/table_screen.dart';

void main() {
  runApp(const TablePlannerApp());
}

class TablePlannerApp extends StatelessWidget {
  const TablePlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TableScreen(), // Supprimé "const" ici
    );
  }
}
