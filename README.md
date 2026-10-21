# PracMob-7

Невеликий демозастосунок доставки їжі. Є кілька ресторанів і страв, кошик, вибір адреси та екран замовлень. Дані зберігаються в пам’яті й скидаються після перезапуску.

## Запуск

```powershell
flutter pub get
flutter analyze
flutter run -d emulator-5554
```

## Маршрути

| Шлях | Екран | Умова |
|---|---|---|
| `/restaurants?sort=rating` або `?sort=distance` | Список ресторанів | — |
| `/restaurants/:restaurantId` | Меню ресторану | — |
| `/restaurants/:restaurantId/dish/:dishId` | Страва | — |
| `/cart` | Кошик | — |
| `/address` | Вибір адреси | Повертає адресу в кошик через `context.pop(value)` |
| `/checkout` | Оформлення | Потрібен вхід і непорожній кошик |
| `/login` | Демовхід | Будь-який коректний email і пароль від 6 символів |
| `/orders` | Активні / виконані замовлення | — |

`GoRouter` налаштований у `lib/router/app_router.dart`. Три вкладки працюють через `StatefulShellRoute.indexedStack`, тому стан вкладки зберігається при перемиканні. `FoodAppState` є `refreshListenable` маршрутизатора: якщо користувач не ввійшов, оформлення перенаправляє на `/login`, а після входу повертає до запитаного шляху; порожній кошик перенаправляє на `/restaurants`. Невідомі адреси обробляє `errorBuilder`.

На формі оформлення `PopScope` питає підтвердження, якщо вже введено коментар або змінено спосіб оплати. Контролери звільняються у `dispose()`. Вибір адреси відкривається через `context.push<String>` і повертає рядок до кошика.

## Deep link

Схема `food://app` зареєстрована в Android `AndroidManifest.xml` та iOS `Info.plist`. Приклад: `food://app/restaurants/basil`. Для локального запуску Android-перевірки:

```powershell
adb shell am start -a android.intent.action.VIEW -d "food://app/restaurants/basil"
```

## Демонстрація

Запис роботи застосунку: [pracmob7-demo.mp4](demo/pracmob7-demo.mp4).

