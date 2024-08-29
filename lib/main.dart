import 'package:KleanApp/routes/public_routes.dart';
import 'package:KleanApp/themes/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light(context),
      routerConfig: routerConfig,
    );
  }
}
