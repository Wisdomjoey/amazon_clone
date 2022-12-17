import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
          builder: ((context) => const AuthScreen()), settings: routeSettings);
    case HomeScreen.routeName:
      return MaterialPageRoute(
          builder: ((context) => const HomeScreen()), settings: routeSettings);
    default:
      return MaterialPageRoute(
          builder: ((context) => const Scaffold(
                body: Center(
                  child: Text('Screen does not exist'),
                ),
              )),
          settings: routeSettings);
  }
}
