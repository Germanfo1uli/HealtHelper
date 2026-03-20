import 'package:flutter/material.dart';

class DayProgressCard extends StatelessWidget {
  const DayProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF9FFF9)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F1C14).withOpacity(0.05),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Сегодня',
                    style: TextStyle(
                      color: Color(0xFF2F3B34),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '20 марта, Пятница',
                    style: TextStyle(
                      color: const Color(0xFF2F3B34).withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Осталось: 850',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: const [
              _HeroRing(),
              SizedBox(width: 32),
              Expanded(child: _MacroList()),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroRing extends StatelessWidget {
  const _HeroRing();

  @override
  Widget build(BuildContext context) {
    const chartColor = Color(0xFF4CAF50);

    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return const SweepGradient(
                startAngle: 0.0,
                endAngle: 3.14 * 2,
                stops: [0.58, 0.58],
                center: Alignment.center,
                colors: [chartColor, Colors.transparent],
              ).createShader(rect);
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: chartColor, width: 12),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: chartColor.withOpacity(0.1), width: 12),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '1250',
                style: TextStyle(
                  color: Color(0xFF2F3B34),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'ккал',
                style: TextStyle(
                  color: const Color(0xFF2F3B34).withOpacity(0.6),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroList extends StatelessWidget {
  const _MacroList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _MacroBar(
          label: 'Белки',
          value: 0.6,
          amount: '60г',
          color: Color(0xFF2E7D32),
        ),
        SizedBox(height: 16),
        _MacroBar(
          label: 'Жиры',
          value: 0.45,
          amount: '45г',
          color: Color(0xFFF2994A),
        ),
        SizedBox(height: 16),
        _MacroBar(
          label: 'Углев.',
          value: 0.7,
          amount: '140г',
          color: Color(0xFF56CCF2),
        ),
      ],
    );
  }
}

class _MacroBar extends StatelessWidget {
  const _MacroBar({
    required this.label,
    required this.value,
    required this.amount,
    required this.color,
  });

  final String label;
  final double value;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF2F3B34),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: const Color(0xFF2F3B34).withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFE9F2EC),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              widthFactor: value,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
