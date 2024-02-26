import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:drift/splash_screen.dart';
import 'package:flutter/material.dart';

Flavor flavor = catppuccin.mocha;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = flavor.mauve;
    Color secondaryColor = flavor.pink;
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme(
            background: flavor.base,
            brightness: Brightness.light,
            error: flavor.surface2,
            onBackground: flavor.text,
            onError: flavor.red,
            onPrimary: primaryColor,
            onSecondary: secondaryColor,
            onSurface: flavor.text,
            primary: flavor.crust,
            secondary: flavor.mantle,
            surface: flavor.surface0,
          ),
          fontFamily: 'FireCode Nerd Font',
          textTheme: const TextTheme().apply(
            bodyColor: flavor.text,
            displayColor: primaryColor,
          )),
      home: const SplashScreen(),
      // home: const SetupPage(),
    );
  }
}
