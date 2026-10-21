import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../food_scope.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _comment = TextEditingController();
  bool _dirty = false;
  bool _allowPop = false;
  bool _cash = true;
  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Вийти без оформлення?'),
        content: const Text('Введений коментар не буде збережено.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Залишитись'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Вийти'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) {
      setState(() => _allowPop = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = FoodScope.of(context);
    return PopScope<Object?>(
      canPop: !_dirty || _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _dirty) _confirmExit();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Оформлення')),
        body: AnimatedBuilder(
          animation: app,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Доставка',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(app.address),
                  subtitle: const Text('Адреса отримана з кошика'),
                ),
              ),
              const SizedBox(height: 21),
              const Text(
                'Коментар до замовлення',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _comment,
                maxLines: 3,
                onChanged: (_) => setState(() => _dirty = true),
                decoration: const InputDecoration(
                  hintText: 'Наприклад, код домофона або побажання',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Оплата',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              RadioListTile<bool>(
                value: true,
                groupValue: _cash,
                onChanged: (value) {
                  setState(() {
                    _cash = value!;
                    _dirty = true;
                  });
                },
                title: const Text('Готівкою кур’єру'),
              ),
              RadioListTile<bool>(
                value: false,
                groupValue: _cash,
                onChanged: (value) {
                  setState(() {
                    _cash = value!;
                    _dirty = true;
                  });
                },
                title: const Text('Карткою при отриманні'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'До сплати',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${app.total} ₴',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: app.address == 'Оберіть адресу доставки'
                    ? null
                    : () {
                        app.placeOrder();
                        context.go('/orders');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Замовлення оформлено')),
                        );
                      },
                child: const Text('Підтвердити замовлення'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
