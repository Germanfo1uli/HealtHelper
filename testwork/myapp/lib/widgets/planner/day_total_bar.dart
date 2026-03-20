import 'package:flutter/material.dart';

class DayTotalBar extends StatelessWidget {
  const DayTotalBar({
    super.key,
    required this.total,
    required this.target,
  });

  final int total;
  final int target;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F1C14).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department_rounded,
              color: Color(0xFF2E7D32)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Итого за день: $total/$target ккал',
              style: const TextStyle(
                color: Color(0xFF2F3B34),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
