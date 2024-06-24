import 'package:flutter/material.dart';
import 'package:zendesk_unified_example/constants/constants.dart';
import 'package:zendesk_unified_example/views/views.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zendesk Unified Example',
      theme: AppConstants().kThemeData,
      home: const MyHomePage(),
    );
  }
}
