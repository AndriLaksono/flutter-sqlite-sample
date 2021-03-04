import 'package:flutter/material.dart';
import './core/constants/strings.dart';
import './core/themes/app_theme.dart';
import './presentation/routers/app_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      theme: AppTheme.normalTheme,
      initialRoute: AppRouter.home,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}