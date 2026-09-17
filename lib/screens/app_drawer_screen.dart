import 'package:flutter/material.dart';
import '../models/app_info.dart';
import '../widgets/app_icon_tile.dart';

class AppDrawerScreen extends StatefulWidget {
  final List<AppInfo> allApps;

  const AppDrawerScreen({super.key, required this.allApps});

  @override
  State<AppDrawerScreen> createState() => _AppDrawerScreenState();
}

class _AppDrawerScreenState extends State<AppDrawerScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.allApps
        .where((a) => a.appName.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.95),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                autofocus: false,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cari aplikasi...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text('Aplikasi tidak ditemukan',
                          style: TextStyle(color: Colors.white54)))
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, i) => AppIconTile(app: filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
