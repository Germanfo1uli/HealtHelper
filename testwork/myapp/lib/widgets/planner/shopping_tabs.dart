import 'package:flutter/material.dart';

import '../../models/planner_models.dart';

class ShoppingTabs extends StatelessWidget {
  const ShoppingTabs({
    super.key,
    required this.cartItems,
    required this.autoItems,
    required this.onToggleBought,
    required this.onClearBought,
    required this.onAddAll,
  });

  final List<ShoppingItem> cartItems;
  final List<String> autoItems;
  final ValueChanged<int> onToggleBought;
  final VoidCallback onClearBought;
  final VoidCallback onAddAll;

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
              Tab(text: 'Моя корзина'),
              Tab(text: 'Нужно купить'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _CartTab(
                  items: cartItems,
                  onToggleBought: onToggleBought,
                  onClearBought: onClearBought,
                ),
                _AutoTab(
                  items: autoItems,
                  onAddAll: onAddAll,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartTab extends StatelessWidget {
  const _CartTab({
    required this.items,
    required this.onToggleBought,
    required this.onClearBought,
  });

  final List<ShoppingItem> items;
  final ValueChanged<int> onToggleBought;
  final VoidCallback onClearBought;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: CheckboxListTile(
                  value: item.isBought,
                  onChanged: (_) => onToggleBought(index),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      color: item.isBought
                          ? const Color(0xFF7A8B80)
                          : const Color(0xFF2F3B34),
                      decoration:
                          item.isBought ? TextDecoration.lineThrough : null,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: items.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: items.any((item) => item.isBought)
                  ? onClearBought
                  : null,
              child: const Text('Очистить купленное'),
            ),
          ),
        ),
      ],
    );
  }
}

class _AutoTab extends StatelessWidget {
  const _AutoTab({
    required this.items,
    required this.onAddAll,
  });

  final List<String> items;
  final VoidCallback onAddAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            itemBuilder: (context, index) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  items[index],
                  style: const TextStyle(
                    color: Color(0xFF2F3B34),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: items.length,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: items.isEmpty ? null : onAddAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
              child: const Text('Добавить всё в корзину'),
            ),
          ),
        ),
      ],
    );
  }
}
