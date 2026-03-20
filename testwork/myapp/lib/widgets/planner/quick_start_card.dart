import 'package:flutter/material.dart';

class QuickStartCard extends StatelessWidget {
  const QuickStartCard({
    super.key,
    required this.onApply,
  });

  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFF2E7D32)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Быстрый старт: Сбалансированный на 2000 ккал',
              style: TextStyle(
                color: Color(0xFF2F3B34),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: onApply,
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }
}
