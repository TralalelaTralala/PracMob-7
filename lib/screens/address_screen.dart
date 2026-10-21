import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});
  static const _addresses = [
    'вул. Університетська, 12',
    'просп. Незалежності, 48',
    'вул. Соборна, 7',
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Адреса доставки')),
    body: ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text(
          'Куди привезти замовлення?',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ..._addresses.map(
          (address) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: Text(address),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pop<String>(address),
            ),
          ),
        ),
      ],
    ),
  );
}
