import 'package:flutter/foundation.dart';

@immutable
class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.distanceKm,
    required this.emoji,
    required this.color,
    required this.dishes,
  });
  final String id, name, cuisine, emoji;
  final double rating, distanceKm;
  final int color;
  final List<Dish> dishes;
}

@immutable
class Dish {
  const Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.emoji,
  });
  final String id, name, description, emoji;
  final int price;
}

@immutable
class CartLine {
  const CartLine({
    required this.restaurant,
    required this.dish,
    required this.quantity,
  });
  final Restaurant restaurant;
  final Dish dish;
  final int quantity;
  CartLine copyWith({int? quantity}) => CartLine(
    restaurant: restaurant,
    dish: dish,
    quantity: quantity ?? this.quantity,
  );
}

@immutable
class FoodOrder {
  const FoodOrder({
    required this.id,
    required this.items,
    required this.total,
    required this.address,
    required this.createdAt,
    required this.completed,
  });
  final String id, address;
  final List<CartLine> items;
  final int total;
  final DateTime createdAt;
  final bool completed;
  FoodOrder copyWith({bool? completed}) => FoodOrder(
    id: id,
    items: items,
    total: total,
    address: address,
    createdAt: createdAt,
    completed: completed ?? this.completed,
  );
}

const demoRestaurants = <Restaurant>[
  Restaurant(
    id: 'basil',
    name: 'Basilico',
    cuisine: 'Італійська кухня · 25–35 хв',
    rating: 4.9,
    distanceKm: 1.2,
    emoji: '🍕',
    color: 0xFFFFE4D8,
    dishes: [
      Dish(
        id: 'margherita',
        name: 'Маргарита',
        description: 'Томатний соус, моцарела, базилік',
        price: 245,
        emoji: '🍕',
      ),
      Dish(
        id: 'pasta',
        name: 'Паста з грибами',
        description: 'Вершковий соус, пармезан',
        price: 285,
        emoji: '🍝',
      ),
      Dish(
        id: 'tiramisu',
        name: 'Тірамісу',
        description: 'Кава, маскарпоне, какао',
        price: 145,
        emoji: '🍰',
      ),
    ],
  ),
  Restaurant(
    id: 'green-bowl',
    name: 'Green Bowl',
    cuisine: 'Здорова їжа · 20–30 хв',
    rating: 4.7,
    distanceKm: 0.8,
    emoji: '🥗',
    color: 0xFFDDF4E8,
    dishes: [
      Dish(
        id: 'salmon',
        name: 'Боул з лососем',
        description: 'Рис, авокадо, лосось, кунжут',
        price: 325,
        emoji: '🍣',
      ),
      Dish(
        id: 'falafel',
        name: 'Боул з фалафелем',
        description: 'Хумус, овочі, соус тахіні',
        price: 235,
        emoji: '🥙',
      ),
      Dish(
        id: 'smoothie',
        name: 'Ягідний смузі',
        description: 'Полуниця, банан, йогурт',
        price: 115,
        emoji: '🫐',
      ),
    ],
  ),
  Restaurant(
    id: 'wok-house',
    name: 'Wok House',
    cuisine: 'Азійська кухня · 30–40 хв',
    rating: 4.8,
    distanceKm: 2.1,
    emoji: '🍜',
    color: 0xFFFFF0C9,
    dishes: [
      Dish(
        id: 'noodles',
        name: 'Локшина з куркою',
        description: 'Овочі, курка, соус теріякі',
        price: 265,
        emoji: '🍜',
      ),
      Dish(
        id: 'bao',
        name: 'Бао з яловичиною',
        description: 'М’яка булочка, овочі, соус',
        price: 185,
        emoji: '🥟',
      ),
      Dish(
        id: 'rice',
        name: 'Рис з овочами',
        description: 'Смажений рис, яйце, овочі',
        price: 195,
        emoji: '🍚',
      ),
    ],
  ),
];
