import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const _sections = [
    _SectionData('Messages', Icons.chat_bubble_outline),
    _SectionData('Contacts', Icons.people_outline),
    _SectionData('Calls', Icons.call_outlined),
    _SectionData('Settings', Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final wide = constraints.maxWidth >= 760;
      return Scaffold(
        body: SafeArea(
          child: Row(children: [
            if (wide) _buildRail(),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildHeader(wide),
              Expanded(child: _selectedIndex == 0 ? _buildMessages() : _buildPlaceholder(_sections[_selectedIndex])),
            ])),
          ]),
        ),
        bottomNavigationBar: wide ? null : NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (value) => setState(() => _selectedIndex = value),
          backgroundColor: AppTheme.surface,
          indicatorColor: AppTheme.accent.withValues(alpha: .2),
          destinations: _sections.map((item) => NavigationDestination(icon: Icon(item.icon), label: item.label)).toList(),
        ),
      );
    },
  );

  Widget _buildRail() => NavigationRail(
    selectedIndex: _selectedIndex,
    onDestinationSelected: (value) => setState(() => _selectedIndex = value),
    backgroundColor: AppTheme.surface,
    indicatorColor: AppTheme.accent.withValues(alpha: .2),
    leading: const Padding(padding: EdgeInsets.symmetric(vertical: 28), child: Icon(Icons.bolt, color: AppTheme.cyan, size: 30)),
    destinations: _sections.map((item) => NavigationRailDestination(icon: Icon(item.icon), label: Text(item.label))).toList(),
  );

  Widget _buildHeader(bool wide) => Padding(
    padding: EdgeInsets.fromLTRB(wide ? 32 : 20, 20, 20, 18),
    child: Row(children: [
      if (!wide) const Icon(Icons.bolt, color: AppTheme.cyan, size: 28),
      if (!wide) const SizedBox(width: 10),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('APOKOLIPS', style: TextStyle(color: AppTheme.cyan, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 2.4)),
        SizedBox(height: 3),
        Text('Messenger', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
      ])),
      IconButton(
        tooltip: 'Sign out',
        onPressed: () async => Supabase.instance.client.auth.signOut(),
        icon: const Icon(Icons.logout),
      ),
      const CircleAvatar(radius: 18, backgroundColor: AppTheme.elevated, child: Icon(Icons.person_outline, size: 20)),
    ]),
  );

  Widget _buildMessages() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search conversations')),
      const SizedBox(height: 24),
      const Text('YOUR INBOX', style: TextStyle(color: AppTheme.secondaryText, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.8)),
      const SizedBox(height: 12),
      Expanded(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: AppTheme.accent.withValues(alpha: .10), shape: BoxShape.circle),
            child: const Icon(Icons.forum_outlined, size: 38, color: AppTheme.cyan),
          ),
          const SizedBox(height: 20),
          const Text('Your conversations start here', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('When you connect your account and start a chat, it will appear in this space.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.secondaryText, height: 1.5)),
        ]),
      ))),
    ]),
  );

  Widget _buildPlaceholder(_SectionData section) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(section.icon, size: 42, color: AppTheme.cyan),
    const SizedBox(height: 14),
    Text(section.label, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
    const SizedBox(height: 6),
    const Text('This section will be introduced in a future phase.', style: TextStyle(color: AppTheme.secondaryText)),
  ]));
}

class _SectionData {
  const _SectionData(this.label, this.icon);
  final String label;
  final IconData icon;
}
