import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/food_app_state.dart';
import '../screens/address_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/food_screens.dart';
import '../screens/login_screen.dart';

GoRouter createRouter(FoodAppState appState) => GoRouter(
  initialLocation: '/restaurants',
  refreshListenable: appState,
  redirect: (context, state) {
    final atLogin = state.matchedLocation == '/login';
    if (state.matchedLocation == '/checkout') {
      if (!appState.signedIn)
        return '/login?from=${Uri.encodeComponent(state.uri.toString())}';
      if (appState.cart.isEmpty) return '/restaurants';
    }
    if (atLogin && appState.signedIn)
      return state.uri.queryParameters['from'] ?? '/restaurants';
    return null;
  },
  errorBuilder: (context, state) => UnknownRouteScreen(error: state.error),
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          FoodShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/restaurants',
              builder: (context, state) => RestaurantListScreen(
                sort: state.uri.queryParameters['sort'] ?? 'rating',
              ),
              routes: [
                GoRoute(
                  path: ':restaurantId',
                  builder: (context, state) => RestaurantScreen(
                    restaurantId: state.pathParameters['restaurantId']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'dish/:dishId',
                      builder: (context, state) => DishScreen(
                        restaurantId: state.pathParameters['restaurantId']!,
                        dishId: state.pathParameters['dishId']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrdersScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) =>
          LoginScreen(from: state.uri.queryParameters['from']),
    ),
    GoRoute(
      path: '/address',
      builder: (context, state) => const AddressScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
  ],
);

class FoodShell extends StatelessWidget {
  const FoodShell({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: NavigationBar(
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.restaurant_outlined),
          selectedIcon: Icon(Icons.restaurant),
          label: 'Ресторани',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_bag_outlined),
          selectedIcon: Icon(Icons.shopping_bag),
          label: 'Кошик',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: 'Замовлення',
        ),
      ],
    ),
  );
}
