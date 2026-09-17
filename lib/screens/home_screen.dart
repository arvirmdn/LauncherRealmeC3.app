import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_info.dart';
import '../services/app_service.dart';
import '../widgets/app_icon_tile.dart';
import '../widgets/clock_widget.dart';
import 'app_drawer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AppInfo> _allApps = [];
  List<AppInfo> _favorites = [];
  bool _loading = true;

  static const _favoritesKey = 'favorite_packages';

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    final apps = await AppService.getInstalledApps();
    final prefs = await SharedPreferences.getInstance();
    final savedFavorites = prefs.getStringList(_favoritesKey);

    List<AppInfo> favorites;
    if (savedFavorites == null) {
      // default: 8 app pertama jadi favorit awal, user bisa ganti nanti
      favorites = apps.take(8).toList();
    } else {
      favorites = apps
          .where((a) => savedFavorites.contains(a.packageName))
          .toList();
    }

    setState(() {
      _allApps = apps;
      _favorites = favorites;
      _loading = false;
    });
  }

  void _openDrawer() {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, anim, __) => FadeTransition(
          opacity: anim,
          child: AppDrawerScreen(allApps: _allApps),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white54)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        // swipe ke atas dari mana aja di home = buka app drawer
        onVerticalDragEnd: (details) {
          if ((details.primaryVelocity ?? 0) < -250) {
            _openDrawer();
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 32),
              const ClockWidget(),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _favorites.length,
                  itemBuilder: (context, i) => AppIconTile(app: _favorites[i]),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _openDrawer,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
