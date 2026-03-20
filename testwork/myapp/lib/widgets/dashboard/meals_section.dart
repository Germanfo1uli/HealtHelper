import 'package:flutter/material.dart';

class MealsSection extends StatelessWidget {
  const MealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Приёмы пищи',
            style: TextStyle(
              color: Color(0xFF2F3B34),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const _MealCard(
          title: 'Завтрак',
          subtitle: 'Греческий йогурт с ягодами',
          time: '08:30',
          status: _MealStatus.done,
          icon: Icons.wb_sunny_rounded,
        ),
        const SizedBox(height: 14),
        const _MealCard(
          title: 'Обед',
          subtitle: 'Гречка с курицей',
          time: '13:00',
          status: _MealStatus.planned,
          icon: Icons.lunch_dining_rounded,
        ),
        const SizedBox(height: 14),
        const _MealCard(
          title: 'Ужин',
          subtitle: 'Рыба на пару и салат',
          time: '19:00',
          status: _MealStatus.upcoming,
          icon: Icons.nights_stay_rounded,
        ),
      ],
    );
  }
}

enum _MealStatus { done, planned, upcoming }

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.status,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String time;
  final _MealStatus status;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final bool isDone = status == _MealStatus.done;
    final color = isDone
        ? const Color(0xFF2E7D32)
        : const Color(0xFF2F3B34).withOpacity(0.4);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDone
              ? const Color(0xFF2E7D32).withOpacity(0.15)
              : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F1C14).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isDone ? const Color(0xFFE8F4EC) : const Color(0xFFF5F7F6),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  color: isDone ? color.withOpacity(0.3) : color,
                  size: 26,
                ),
                if (isDone)
                  const Positioned(
                    right: 8,
                    bottom: 8,
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF2E7D32),
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF2F3B34),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDone
                            ? const Color(0xFF2E7D32).withOpacity(0.08)
                            : const Color(0xFFF5F7F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isDone
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFF2F3B34).withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: const Color(0xFF2F3B34).withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
