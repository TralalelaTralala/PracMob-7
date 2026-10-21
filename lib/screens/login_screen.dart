import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../food_scope.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({this.from, super.key});
  final String? from;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    FoodScope.of(context).signIn(_email.text.trim());
    context.go(widget.from ?? '/restaurants');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Вхід')),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.delivery_dining,
                    size: 42,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Увійти, щоб замовити',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Введи email і пароль для оформлення доставки.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.mail_outline),
                  ),
                  validator: (value) =>
                      value != null &&
                          RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                              .hasMatch(value.trim())
                      ? null
                      : 'Введи коректний email',
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) => value != null && value.length >= 6
                      ? null
                      : 'Пароль має містити щонайменше 6 символів',
                ),
                const SizedBox(height: 22),
                FilledButton(
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Увійти'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Це демонстраційний вхід — підійде будь-який email і пароль.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
