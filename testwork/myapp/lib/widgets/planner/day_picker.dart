import 'package:flutter/material.dart';

class DayPicker extends StatelessWidget {
  const DayPicker({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<DateTime> days;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  String _weekdayLabel(DateTime date) {
    const labels = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return labels[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {
          final date = days[index];
          final isActive = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              width: 64,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF2E7D32) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFE3E8E3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weekdayLabel(date),
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF7A8B80),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isActive ? Colors.white : const Color(0xFF2F3B34),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: days.length,
      ),
    );
  }
}
