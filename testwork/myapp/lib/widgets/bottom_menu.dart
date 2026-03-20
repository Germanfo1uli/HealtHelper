import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({
    super.key,
    required this.index,
    required this.tabs,
    required this.onSelect,
  });

  final int index;
  final List<TabData> tabs;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const barHeight = 72.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: SizedBox(
        height: barHeight + 28,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: barHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.16),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(36),
                      onTap: () => onSelect(0),
                      child: _NavIcon(
                        active: index == 0,
                        icon: tabs[0].icon,
                      ),
                    ),
                  ),
                  const SizedBox(width: 72),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(36),
                      onTap: () => onSelect(2),
                      child: _NavIcon(
                        active: index == 2,
                        icon: tabs[2].icon,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: _ScanButton(
                active: index == 1,
                onTap: () => onSelect(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.active, required this.icon});

  final bool active;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF2E7D32).withOpacity(0.12)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 260),
          scale: active ? 1.05 : 1.0,
          child: Icon(
            icon,
            size: active ? 28 : 24,
            color: active ? const Color(0xFF2E7D32) : const Color(0xFF7A8B80),
          ),
        ),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        width: 78,
        height: 78,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF3BBE74)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E7D32).withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 260),
          scale: active ? 1.03 : 1.0,
          child: const Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}

class TabData {
  const TabData(this.title, this.icon);

  final String title;
  final IconData icon;
}
