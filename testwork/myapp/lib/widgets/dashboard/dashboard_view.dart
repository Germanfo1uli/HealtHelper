import 'package:flutter/material.dart';
import 'day_progress_card.dart';
import 'meals_section.dart';
import 'profile_header.dart';
import 'recent_scans.dart';
import 'tip_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FBF6),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
          children: const [
            ProfileHeader(),
            SizedBox(height: 24),
            DayProgressCard(),
            SizedBox(height: 24),
            _QuickStatsRow(),
            SizedBox(height: 24),
            MealsSection(),
            SizedBox(height: 24),
            RecentScans(),
            SizedBox(height: 24),
            TipCard(),
          ],
        ),
      ),
    );
  }
}

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _StatChip(
            title: 'Вода',
            value: '5',
            total: '/ 8',
            unit: 'стаканов',
            icon: Icons.water_drop_rounded,
            accentColor: const Color(0xFF42A5F5),
            isWater: true,
            onActionPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: _StatChip(
            title: 'Шаги',
            value: '6 240',
            total: '',
            unit: 'из 10 000',
            icon: Icons.directions_walk_rounded,
            progress: 0.624,
            accentColor: Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.title,
    required this.value,
    required this.total,
    required this.unit,
    required this.icon,
    this.progress,
    required this.accentColor,
    this.isWater = false,
    this.onActionPressed,
  });

  final String title;
  final String value;
  final String total;
  final String unit;
  final IconData icon;
  final double? progress;
  final Color accentColor;
  final bool isWater;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 160),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F1C14).withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              if (isWater)
                _WaterAddButton(
                  accentColor: accentColor,
                  onPressed: onActionPressed,
                )
              else if (progress != null)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 4,
                        color: accentColor.withOpacity(0.15),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 4,
                        color: accentColor,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF2F3B34),
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (total.isNotEmpty)
                    Text(
                      total,
                      style: TextStyle(
                        color: const Color(0xFF2F3B34).withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '$title • $unit',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF2F3B34).withOpacity(0.6),
                  fontSize: 12,
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

class _WaterAddButton extends StatefulWidget {
  const _WaterAddButton({
    required this.accentColor,
    this.onPressed,
  });

  final Color accentColor;
  final VoidCallback? onPressed;

  @override
  State<_WaterAddButton> createState() => _WaterAddButtonState();
}

class _WaterAddButtonState extends State<_WaterAddButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: widget.accentColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color:
                    widget.accentColor.withOpacity(_pressed ? 0.18 : 0.3),
                blurRadius: _pressed ? 6 : 8,
                offset: Offset(0, _pressed ? 2 : 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
