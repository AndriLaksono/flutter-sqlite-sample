import 'package:flutter/material.dart';
import 'package:ft_sqlite_shop1/presentation/screens/items_screen/items.dart';
import '../../core/constants/strings.dart';
import '../../core/exceptions/route_exception.dart';
import '../screens/home_screen/home.dart';

class AppRouter {
  static const String home = '/';
  static const String items = '/items';
  static const String items_detail = '/items/detail';

  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // args is data parameter if we want pass data to other screen
    final args = settings.arguments;
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
            builder: (_) => ShList(title: Strings.appTitle));
      case items:
        return MaterialPageRoute(
            builder: (_) => ItemsScreen(args));
      case items_detail:
        // return MaterialPageRoute(
        //     builder: (_) => AddSoundPage(title: 'Add Sound'));
      default:
        throw const RouteException('Route not found!');
    }
  }
}
