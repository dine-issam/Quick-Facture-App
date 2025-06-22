import 'package:flutter/material.dart';
import 'package:quick_facture/screens/invoice_screren.dart';

void main() {
  runApp(const QuickFactureApp());
}

class QuickFactureApp extends StatelessWidget {
  const QuickFactureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quick Facture',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const InvoiceScreen(),
    );
  }
}
