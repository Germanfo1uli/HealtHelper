import 'package:flutter/material.dart';

import '../widgets/bottom_menu.dart';
import '../widgets/header_card.dart';
import '../widgets/section_placeholder.dart';
import '../widgets/dashboard/dashboard_view.dart';
import 'scan/scan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final List<TabData> _tabs = const [
    TabData('Р“Р»Р°РІРЅР°СЏ', Icons.spa_rounded),
    TabData('РЎРєР°РЅ', Icons.qr_code_scanner_rounded),
    TabData('Планировщик', Icons.calendar_month_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[_index];
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6FBF7), Color(0xFFEAF4EE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              if (_index != 0) ...[
                HeaderCard(title: tab.title),
                const SizedBox(height: 20),
              ],
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _index == 0
                      ? const DashboardView(key: ValueKey('dashboard'))
                      : SectionPlaceholder(
                          key: ValueKey(tab.title),
                          icon: tab.icon,
                          title: tab.title,
                        ),
                ),
              ),
              const SizedBox(height: 12),
              BottomMenu(
                index: _index,
                tabs: _tabs,
                onSelect: (value) {
                  if (value == 1) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ScanScreen(),
                      ),
                    );
                    return;
                  }
                  setState(() => _index = value);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

