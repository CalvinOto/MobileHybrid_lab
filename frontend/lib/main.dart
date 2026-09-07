import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/user/home_screen.dart';
import 'services/auth_service.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const HonkaiStarRetailApp());
}

class HonkaiStarRetailApp extends StatelessWidget {
  const HonkaiStarRetailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Honkai Star Retail',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    final loggedIn = await AuthService.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      final role = await AuthService.getRole();
      final dest = role == 'admin'
          ? const AdminDashboardScreen()
          : const HomeScreen();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => dest),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
                Icons.auto_awesome,
                color: AppTheme.cyan,
                size: 64),

            const SizedBox(height: 24),

            const Text(
                'Honkai Star Retail',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary)),
            const SizedBox(height: 8),
            const Text(
                'Your galactic marketplace',
                style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14)),
            const SizedBox(height: 48),

            const SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                    backgroundColor: AppTheme.bgSurface,
                    color: AppTheme.cyan,
                    minHeight: 2)),
          ],
        ),
      ),
    );
  }
}