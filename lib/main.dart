import 'package:flutter/material.dart';

import 'food_scope.dart';
import 'models/food_app_state.dart';
import 'router/app_router.dart';

void main() {
  final appState = FoodAppState();
  runApp(
    FoodScope(
      appState: appState,
      child: FoodDeliveryApp(appState: appState),
    ),
  );
}

class FoodDeliveryApp extends StatefulWidget {
  const FoodDeliveryApp({required this.appState, super.key});
  final FoodAppState appState;
  @override
  State<FoodDeliveryApp> createState() => _FoodDeliveryAppState();
}

class _FoodDeliveryAppState extends State<FoodDeliveryApp> {
  late final router = createRouter(widget.appState);
  @override
  void dispose() {
    router.dispose();
    widget.appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Смак поруч',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFEF6747),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFFFAF7),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    ),
    routerConfig: router,
  );
}
