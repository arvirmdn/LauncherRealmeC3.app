import 'package:flutter/material.dart';
import '../models/app_info.dart';
import '../services/app_service.dart';

class AppIconTile extends StatelessWidget {
  final AppInfo app;
  final VoidCallback? onLongPressExtra;

  const AppIconTile({super.key, required this.app, this.onLongPressExtra});

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1C1C1E),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.white),
              title: const Text('Info Aplikasi', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                AppService.openAppSettings(app.packageName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text('Uninstall', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                AppService.uninstallApp(app.packageName);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppService.openApp(app.packageName),
      onLongPress: () => _showOptions(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: app.icon != null
                ? Image.memory(app.icon!, width: 52, height: 52, fit: BoxFit.cover)
                : Container(
                    width: 52,
                    height: 52,
                    color: Colors.grey[800],
                    child: const Icon(Icons.apps, color: Colors.white54),
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            app.appName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
