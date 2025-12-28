import 'package:flutter/cupertino.dart';
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
    return CupertinoApp(
      title: 'Plan de Table',
      theme: const CupertinoThemeData(
        primaryColor: CupertinoColors.systemBlue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: CupertinoColors.systemBackground,
      ),
      home: TableScreen(),
    );
  }
}