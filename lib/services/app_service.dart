import 'package:device_apps/device_apps.dart';
import '../models/app_info.dart';

class AppService {
  /// Ambil semua aplikasi yang punya launch icon (bukan system service dsb).
  /// includeSystemApps: true supaya app bawaan Realme (Kamera, Setelan, dll) ikut muncul.
  static Future<List<AppInfo>> getInstalledApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );

    apps.sort((a, b) =>
        a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));

    return apps.map((a) {
      final icon = a is ApplicationWithIcon ? a.icon : null;
      return AppInfo(
        appName: a.appName,
        packageName: a.packageName,
        icon: icon,
      );
    }).toList();
  }

  static Future<void> openApp(String packageName) async {
    DeviceApps.openApp(packageName);
  }

  static Future<void> openAppSettings(String packageName) async {
    DeviceApps.openAppSettings(packageName);
  }

  static Future<void> uninstallApp(String packageName) async {
    await DeviceApps.uninstallApp(packageName);
  }
}
