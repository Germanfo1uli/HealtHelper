import 'package:flutter/material.dart';

class StatsTab extends StatelessWidget {
  const StatsTab({
    super.key,
    required this.heightCm,
    required this.weightKg,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.todayCalories,
    required this.yesterdayCalories,
  });

  final int heightCm;
  final int weightKg;
  final int protein;
  final int fat;
  final int carbs;
  final int todayCalories;
  final int yesterdayCalories;

  @override
  Widget build(BuildContext context) {
    const kcalTarget = 2200;
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      children: [
        const _HeroMotivation(
          title: 'Лёгкая победа дня',
          subtitle:
              'Слабость - это временно, а надпись "Я ленивая задница" на лбу - вечна.',
        ),
        const SizedBox(height: 14),
        _StatsCard(
          title: 'Профиль',
          accent: const Color(0xFF3BBE74),
          child: Column(
            children: [
              Row(
                children: [
                  _StatChip(label: 'Рост', value: '$heightCm см'),
                  const SizedBox(width: 10),
                  _StatChip(label: 'Вес', value: '$weightKg кг'),
                  const SizedBox(width: 10),
                  _StatChip(label: 'Цель', value: 'Форма'),
                ],
              ),
              const SizedBox(height: 12),
              _GoalProgress(
                label: 'До цели',
                percentLeft: _calcPercentLeft(weightKg),
                accent: const Color(0xFF3BBE74),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _StatsCard(
          title: 'БЖУ за день',
          accent: const Color(0xFF6C63FF),
          child: Column(
            children: [
              _MacroBar(
                label: 'Белки',
                value: protein,
                goal: 130,
                color: const Color(0xFF6C63FF),
              ),
              const SizedBox(height: 10),
              _MacroBar(
                label: 'Жиры',
                value: fat,
                goal: 70,
                color: const Color(0xFFFFB74D),
              ),
              const SizedBox(height: 10),
              _MacroBar(
                label: 'Углеводы',
                value: carbs,
                goal: 240,
                color: const Color(0xFF29B6F6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _StatsCard(
          title: 'Калории',
          accent: const Color(0xFFFF8A65),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _KcalRow(label: 'Сегодня', value: todayCalories),
              const SizedBox(height: 6),
              _KcalRow(label: 'Вчера', value: yesterdayCalories),
              const SizedBox(height: 12),
              Row(
                children: [
                  _LegendDot(color: const Color(0xFF42A5F5), label: 'В норме'),
                  const SizedBox(width: 14),
                  _LegendDot(color: const Color(0xFFE57373), label: 'Перебор'),
                ],
              ),
              const SizedBox(height: 10),
              _MiniChart(
                values: [
                  yesterdayCalories.toDouble(),
                  todayCalories.toDouble(),
                  2100,
                  2350,
                  1980,
                ],
                goodColor: const Color(0xFF42A5F5),
                badColor: const Color(0xFFE57373),
                threshold: kcalTarget.toDouble(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _StatsCard(
          title: 'Активность',
          accent: const Color(0xFF2E7D32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Мини‑челлендж: +1 стакан и +30 минут сна.',
                style: TextStyle(
                  color: Color(0xFF2F3B34),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12),
              _ActivityStat(
                title: 'Вода',
                today: '1.6 л',
                todayTarget: '2.0 л',
                yesterday: '1.9 л',
                yesterdayTarget: '2.0 л',
                todayProgress: 0.8,
                yesterdayProgress: 0.95,
                todayColor: Color(0xFF29B6F6),
                yesterdayColor: Color(0xFF26A69A),
              ),
              SizedBox(height: 14),
              _ActivityStat(
                title: 'Сон',
                today: '6ч 20м',
                todayTarget: '8ч 00м',
                yesterday: '7ч 10м',
                yesterdayTarget: '8ч 00м',
                todayProgress: 0.79,
                yesterdayProgress: 0.89,
                todayColor: Color(0xFF7E57C2),
                yesterdayColor: Color(0xFF8E24AA),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _StatsCard(
          title: 'Месяц в цифрах',
          accent: const Color(0xFF42A5F5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _MonthSummaryRow(
                label: 'Дней в норме',
                value: '18 из 30',
                color: Color(0xFF42A5F5),
              ),
              const SizedBox(height: 8),
              const _MonthSummaryRow(
                label: 'Средние калории',
                value: '1940 ккал',
                color: Color(0xFF6C63FF),
              ),
              const SizedBox(height: 8),
              const _MonthSummaryRow(
                label: 'Лучший стрик',
                value: '6 дней',
                color: Color(0xFF3BBE74),
              ),
              const SizedBox(height: 12),
              _MonthChart(
                values: const [
                  2100, 1980, 1750, 2250, 1900, 2050, 1800,
                  2000, 2150, 1700, 1850, 1950, 2100, 2300,
                  1780, 1880, 2020, 1960, 1900, 1840, 2200,
                  2050, 1920, 1980, 2100, 1760, 1880, 1990,
                  2080, 1860,
                ],
                threshold: 2200,
                goodColor: const Color(0xFF42A5F5),
                badColor: const Color(0xFFE57373),
              ),
              const SizedBox(height: 8),
              const Text(
                'Синий — в норме, красный — перебор по калориям.',
                style: TextStyle(
                  color: Color(0xFF7A8B80),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static int _calcPercentLeft(int weightKg) {
    const goalWeight = 68;
    const startWeight = 85;
    if (weightKg <= goalWeight) {
      return 0;
    }
    if (startWeight <= goalWeight) {
      return 0;
    }
    final percent =
        (((weightKg - goalWeight) / (startWeight - goalWeight)) * 100).round();
    return percent.clamp(1, 99);
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.title,
    required this.child,
    this.accent = const Color(0xFF2E7D32),
  });

  final String title;
  final Widget child;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F1C14).withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF2F3B34),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F6F4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7A8B80),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF2F3B34),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMotivation extends StatelessWidget {
  const _HeroMotivation({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF3BBE74)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E7D32).withOpacity(0.25),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
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

class _KcalRow extends StatelessWidget {
  const _KcalRow({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7A8B80),
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          '$value ккал',
          style: const TextStyle(
            color: Color(0xFF2F3B34),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _MiniChart extends StatelessWidget {
  const _MiniChart({
    required this.values,
    required this.goodColor,
    required this.badColor,
    required this.threshold,
  });

  final List<double> values;
  final Color goodColor;
  final Color badColor;
  final double threshold;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return SizedBox(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final value in values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 20 + (value / maxValue) * 60,
                  decoration: BoxDecoration(
                    color: value <= threshold ? goodColor : badColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  final String label;
  final int value;
  final int goal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final progress = (value / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF7A8B80),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '$value/$goal г',
              style: const TextStyle(
                color: Color(0xFF2F3B34),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: const Color(0xFFE3E8E3),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7A8B80),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _GoalProgress extends StatelessWidget {
  const _GoalProgress({
    required this.label,
    required this.percentLeft,
    required this.accent,
  });

  final String label;
  final int percentLeft;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final progress = percentLeft / 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF7A8B80),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '$percentLeft%',
              style: const TextStyle(
                color: Color(0xFF2F3B34),
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: const Color(0xFFE3E8E3),
            valueColor: AlwaysStoppedAnimation(accent),
          ),
        ),
      ],
    );
  }
}

class _ActivityStat extends StatelessWidget {
  const _ActivityStat({
    required this.title,
    required this.today,
    required this.todayTarget,
    required this.yesterday,
    required this.yesterdayTarget,
    required this.todayProgress,
    required this.yesterdayProgress,
    required this.todayColor,
    required this.yesterdayColor,
  });

  final String title;
  final String today;
  final String todayTarget;
  final String yesterday;
  final String yesterdayTarget;
  final double todayProgress;
  final double yesterdayProgress;
  final Color todayColor;
  final Color yesterdayColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF2F3B34),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        _ActivityRow(
          label: 'Сегод.',
          value: today,
          target: todayTarget,
          progress: todayProgress,
          color: todayColor,
        ),
        const SizedBox(height: 8),
        _ActivityRow(
          label: 'Вчера',
          value: yesterday,
          target: yesterdayTarget,
          progress: yesterdayProgress,
          color: yesterdayColor,
        ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.label,
    required this.value,
    required this.target,
    required this.progress,
    required this.color,
  });

  final String label;
  final String value;
  final String target;
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7A8B80),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF2F3B34),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '/ $target',
                    style: const TextStyle(
                      color: Color(0xFF7A8B80),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE3E8E3),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MonthSummaryRow extends StatelessWidget {
  const _MonthSummaryRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF7A8B80),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF2F3B34),
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _MonthChart extends StatelessWidget {
  const _MonthChart({
    required this.values,
    required this.threshold,
    required this.goodColor,
    required this.badColor,
  });

  final List<int> values;
  final int threshold;
  final Color goodColor;
  final Color badColor;

  @override
  Widget build(BuildContext context) {
    final maxValue = values.reduce((a, b) => a > b ? a : b).toDouble();
    return SizedBox(
      height: 84,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final value in values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Container(
                  height: 10 + (value / maxValue) * 64,
                  decoration: BoxDecoration(
                    color: value <= threshold ? goodColor : badColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
