import 'package:flutter/widgets.dart';

import 'models/food_app_state.dart';

class FoodScope extends InheritedNotifier<FoodAppState> {
  const FoodScope({
    required FoodAppState appState,
    required super.child,
    super.key,
  }) : super(notifier: appState);
  static FoodAppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FoodScope>()!.notifier!;
}
