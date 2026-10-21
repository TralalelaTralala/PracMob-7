import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../food_scope.dart';
import '../models/food_app_state.dart';
import '../models/food_data.dart';

const _ink = Color(0xFF25243A);
const _muted = Color(0xFF777586);

Restaurant? _findRestaurant(String id) {
  for (final restaurant in demoRestaurants) {
    if (restaurant.id == id) return restaurant;
  }
  return null;
}

class RestaurantListScreen extends StatelessWidget {
  const RestaurantListScreen({required this.sort, super.key});
  final String sort;
  @override
  Widget build(BuildContext context) {
    final restaurants = [...demoRestaurants]
      ..sort(
        (a, b) => sort == 'distance'
            ? a.distanceKm.compareTo(b.distanceKm)
            : b.rating.compareTo(a.rating),
      );
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Смачно — поруч',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                              color: _ink,
                            ),
                          ),
                        ),
                        IconButton.filledTonal(
                          onPressed: () => context.go('/cart'),
                          icon: const Icon(Icons.shopping_bag_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Що сьогодні замовимо?',
                      style: TextStyle(color: _muted),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 135,
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF6747), Color(0xFFF19456)],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ОБІД БЕЗ КЛОПОТУ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    letterSpacing: 1.4,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Улюблена їжа\nвже прямує до тебе',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text('🥡', style: TextStyle(fontSize: 62)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Ресторани',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: _ink,
                            ),
                          ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: sort == 'distance' ? 'distance' : 'rating',
                            borderRadius: BorderRadius.circular(14),
                            items: const [
                              DropdownMenuItem(
                                value: 'rating',
                                child: Text('За рейтингом'),
                              ),
                              DropdownMenuItem(
                                value: 'distance',
                                child: Text('За відстанню'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null)
                                context.go('/restaurants?sort=$value');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              sliver: SliverList.separated(
                itemCount: restaurants.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) =>
                    _RestaurantCard(restaurant: restaurants[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.restaurant});
  final Restaurant restaurant;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => context.push('/restaurants/${restaurant.id}'),
    borderRadius: BorderRadius.circular(22),
    child: Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEFECEF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: Color(restaurant.color),
                borderRadius: BorderRadius.circular(17),
              ),
              alignment: Alignment.center,
              child: Text(
                restaurant.emoji,
                style: const TextStyle(fontSize: 38),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    restaurant.cuisine,
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFF0A43A),
                        size: 17,
                      ),
                      Text(
                        ' ${restaurant.rating}  ·  ${restaurant.distanceKm} км',
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _muted),
          ],
        ),
      ),
    ),
  );
}

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({required this.restaurantId, super.key});
  final String restaurantId;
  @override
  Widget build(BuildContext context) {
    final restaurant = _findRestaurant(restaurantId);
    if (restaurant == null) return const UnknownRouteScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        actions: [
          IconButton(
            onPressed: () => context.go('/cart'),
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: Color(restaurant.color),
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: Text(restaurant.emoji, style: const TextStyle(fontSize: 78)),
          ),
          const SizedBox(height: 17),
          Text(restaurant.cuisine, style: const TextStyle(color: _muted)),
          const SizedBox(height: 23),
          const Text(
            'Меню',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: _ink,
            ),
          ),
          const SizedBox(height: 12),
          ...restaurant.dishes.map(
            (dish) => _DishTile(restaurant: restaurant, dish: dish),
          ),
        ],
      ),
    );
  }
}

class _DishTile extends StatelessWidget {
  const _DishTile({required this.restaurant, required this.dish});
  final Restaurant restaurant;
  final Dish dish;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: () =>
            context.push('/restaurants/${restaurant.id}/dish/${dish.id}'),
        borderRadius: BorderRadius.circular(19),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Text(dish.emoji, style: const TextStyle(fontSize: 34)),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dish.name,
                      style: const TextStyle(
                        color: _ink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dish.description,
                      style: const TextStyle(color: _muted, fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${dish.price} ₴',
                      style: const TextStyle(
                        color: Color(0xFFEA6346),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  FoodScope.of(context).add(restaurant, dish);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${dish.name} додано до кошика'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class DishScreen extends StatelessWidget {
  const DishScreen({
    required this.restaurantId,
    required this.dishId,
    super.key,
  });
  final String restaurantId, dishId;
  @override
  Widget build(BuildContext context) {
    final restaurant = _findRestaurant(restaurantId);
    final matchingDishes = restaurant?.dishes.where(
      (item) => item.id == dishId,
    );
    final dish = matchingDishes == null || matchingDishes.isEmpty
        ? null
        : matchingDishes.first;
    if (restaurant == null || dish == null) return const UnknownRouteScreen();
    return Scaffold(
      appBar: AppBar(title: const Text('Страва')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(restaurant.color),
                  borderRadius: BorderRadius.circular(28),
                ),
                alignment: Alignment.center,
                child: Text(dish.emoji, style: const TextStyle(fontSize: 110)),
              ),
            ),
            const SizedBox(height: 22),
            Text(
              dish.name,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: _ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(dish.description, style: const TextStyle(color: _muted)),
            const Spacer(),
            FilledButton.icon(
              onPressed: () {
                FoodScope.of(context).add(restaurant, dish);
                context.go('/cart');
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: Text('До кошика · ${dish.price} ₴'),
            ),
          ],
        ),
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final app = FoodScope.of(context);
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Кошик')),
        body: app.cart.isEmpty
            ? const _EmptyState(
                icon: Icons.shopping_bag_outlined,
                title: 'Поки що порожньо',
                subtitle: 'Додай щось смачне з меню ресторанів.',
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ...app.cart.map(
                    (line) => _CartLineTile(line: line, app: app),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final selected = await context.push<String>('/address');
                      if (selected != null) app.setAddress(selected);
                    },
                    icon: const Icon(Icons.location_on_outlined),
                    label: Text(app.address, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Разом',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${app.total} ₴',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEA6346),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                  FilledButton(
                    onPressed: () => context.go('/checkout'),
                    child: const Text('Перейти до оформлення'),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({required this.line, required this.app});
  final CartLine line;
  final FoodAppState app;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Row(
          children: [
            Text(line.dish.emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.dish.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${line.dish.price} ₴ · ${line.restaurant.name}',
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => app.changeQuantity(line.dish, -1),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('${line.quantity}'),
            IconButton(
              onPressed: () => app.changeQuantity(line.dish, 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    ),
  );
}

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = FoodScope.of(context);
    return AnimatedBuilder(
      animation: app,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Замовлення'),
          bottom: TabBar(
            controller: _tabs,
            tabs: const [
              Tab(text: 'Активні'),
              Tab(text: 'Виконані'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabs,
          children: [
            _OrderList(
              orders: app.orders.where((o) => !o.completed).toList(),
              app: app,
            ),
            _OrderList(
              orders: app.orders.where((o) => o.completed).toList(),
              app: app,
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  const _OrderList({required this.orders, required this.app});
  final List<FoodOrder> orders;
  final FoodAppState app;
  @override
  Widget build(BuildContext context) => orders.isEmpty
      ? const _EmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'Тут з’являться замовлення',
          subtitle: 'Оформлені замовлення можна буде відстежувати тут.',
        )
      : ListView(
          padding: const EdgeInsets.all(18),
          children: orders
              .map(
                (order) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Замовлення ${order.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          order.items
                              .map(
                                (line) =>
                                    '${line.dish.name} × ${line.quantity}',
                              )
                              .join(', '),
                          style: const TextStyle(color: _muted),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${order.total} ₴ · ${order.address}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (!order.completed)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => app.completeOrder(order.id),
                              child: const Text('Позначити виконаним'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 58, color: const Color(0xFFEF6747)),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: _ink,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted),
          ),
        ],
      ),
    ),
  );
}

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({this.error, super.key});
  final Exception? error;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 52),
            const SizedBox(height: 12),
            const Text(
              'Такої сторінки немає',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ??
                  'Перевір адресу або повернись до списку ресторанів.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () => context.go('/restaurants'),
              child: const Text('До ресторанів'),
            ),
          ],
        ),
      ),
    ),
  );
}
