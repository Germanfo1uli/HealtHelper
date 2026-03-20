import 'package:flutter/material.dart';

class RecentScans extends StatelessWidget {
  const RecentScans({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3EFE7)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F1C14).withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Последние сканы',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 156,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _ScanCard(
                  title: 'Йогурт',
                  subtitle: '120 ккал',
                  emoji: '🥣',
                ),
                _ScanCard(
                  title: 'Гранола',
                  subtitle: '210 ккал',
                  emoji: '🥜',
                ),
                _ScanCard(
                  title: 'Смузи',
                  subtitle: '160 ккал',
                  emoji: '🥤',
                ),
                _ScanCard(
                  title: 'Салат',
                  subtitle: '95 ккал',
                  emoji: '🥗',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
  });

  final String title;
  final String subtitle;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 152,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FDFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3EFE7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFE4F2EA),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6F1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E7D32),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
