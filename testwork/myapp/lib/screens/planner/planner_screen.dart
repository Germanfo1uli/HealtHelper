import 'package:flutter/material.dart';

import '../../models/planner_models.dart';
import '../../widgets/planner/day_picker.dart';
import '../../widgets/planner/day_total_bar.dart';
import '../../widgets/planner/meal_section.dart';
import '../../widgets/planner/quick_start_card.dart';
import '../../widgets/planner/shopping_tabs.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final List<DateTime> _days = List.generate(
    7,
    (index) => DateTime.now().add(Duration(days: index)),
  );
  int _selectedDayIndex = 0;

  final Map<DateTime, Map<MealType, List<MealItem>>> _plan = {};

  final List<ShoppingItem> _cartItems = [
    ShoppingItem(name: 'Йогурт греческий'),
    ShoppingItem(name: 'Овсянка'),
  ];

  @override
  void initState() {
    super.initState();
    _seedPlans();
  }

  void _seedPlans() {
    for (final day in _days) {
      _plan[day] = {
        MealType.breakfast: [],
        MealType.lunch: [],
        MealType.dinner: [],
        MealType.snacks: [],
      };
    }
    _plan[_days[0]]?[MealType.breakfast]?.addAll([
      MealItem(name: 'Овсянка', grams: 250),
      MealItem(name: 'Яблоко', grams: 120),
    ]);
    _plan[_days[0]]?[MealType.lunch]?.addAll([
      MealItem(name: 'Куриное филе', grams: 180),
      MealItem(name: 'Гречка', grams: 150),
    ]);
  }

  Map<MealType, List<MealItem>> get _currentMeals =>
      _plan[_days[_selectedDayIndex]]!;

  void _addProduct(MealType type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Добавить продукт в "${type.title}"'),
      ),
    );
  }

  void _deleteProduct(MealType type, int index) {
    setState(() => _currentMeals[type]!.removeAt(index));
  }

  Future<void> _editGrams(MealType type, int index) async {
    final controller = TextEditingController(
      text: _currentMeals[type]![index].grams.toString(),
    );
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Изменить граммовку'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Например: 150',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                Navigator.of(context).pop(value);
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
    if (result == null) {
      return;
    }
    setState(() => _currentMeals[type]![index].grams = result);
  }

  void _applyQuickStart() {
    setState(() {
      _currentMeals[MealType.breakfast] = [
        MealItem(name: 'Омлет', grams: 200),
        MealItem(name: 'Тост цельнозерновой', grams: 80),
      ];
      _currentMeals[MealType.lunch] = [
        MealItem(name: 'Индейка', grams: 180),
        MealItem(name: 'Булгур', grams: 140),
      ];
      _currentMeals[MealType.dinner] = [
        MealItem(name: 'Лосось', grams: 160),
        MealItem(name: 'Овощи гриль', grams: 200),
      ];
      _currentMeals[MealType.snacks] = [
        MealItem(name: 'Творог', grams: 150),
      ];
    });
  }

  List<String> _autoShoppingItems() {
    final tomorrow = _days.length > 1 ? _days[1] : _days.first;
    final meals = _plan[tomorrow]!;
    final items = <String>[];
    for (final entry in meals.entries) {
      for (final item in entry.value) {
        items.add('${item.name} (${item.grams} г)');
      }
    }
    if (items.isEmpty) {
      return const ['План на завтра пока пуст.'];
    }
    return items;
  }

  void _addAllToCart(List<String> items) {
    setState(() {
      for (final item in items) {
        if (item.startsWith('План на завтра')) {
          continue;
        }
        _cartItems.add(ShoppingItem(name: item));
      }
    });
  }

  int _calcTotalCalories() {
    final totalItems = _currentMeals.values.fold<int>(
      0,
      (sum, items) => sum + items.length,
    );
    return totalItems * 260;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Color(0xFF2E7D32),
            unselectedLabelColor: Color(0xFF7A8B80),
            indicatorColor: Color(0xFF2E7D32),
            tabs: [
              Tab(text: 'План питания'),
              Tab(text: 'Список покупок'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView(
                  padding: const EdgeInsets.only(top: 12, bottom: 4),
                  children: [
                    DayPicker(
                      days: _days,
                      selectedIndex: _selectedDayIndex,
                      onSelect: (index) =>
                          setState(() => _selectedDayIndex = index),
                    ),
                    const SizedBox(height: 6),
                    QuickStartCard(onApply: _applyQuickStart),
                    const SizedBox(height: 12),
                    for (final type in MealType.values) ...[
                      MealSection(
                        type: type,
                        items: _currentMeals[type]!,
                        onAdd: () => _addProduct(type),
                        onDelete: (index) => _deleteProduct(type, index),
                        onEditGrams: (index) => _editGrams(type, index),
                      ),
                      const SizedBox(height: 12),
                    ],
                    DayTotalBar(
                      total: _calcTotalCalories(),
                      target: 2200,
                    ),
                  ],
                ),
                ShoppingTabs(
                  cartItems: _cartItems,
                  autoItems: _autoShoppingItems(),
                  onToggleBought: (index) {
                    setState(
                        () => _cartItems[index].isBought = !_cartItems[index].isBought);
                  },
                  onClearBought: () {
                    setState(() => _cartItems.removeWhere((item) => item.isBought));
                  },
                  onAddAll: () => _addAllToCart(_autoShoppingItems()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
