import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../services/auth_service.dart';
import '../../utils/app_theme.dart';
import '../admin/admin_dashboard_screen.dart';
import '../user/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  bool _googleLoading = false;

  final _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId: '492449251005-uq3l8td7qc98vcvna0b5mq22l0q3haia.apps.googleusercontent.com',
  );

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? AppTheme.danger : AppTheme.success,
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final result = await AuthService.login(
        _emailCtrl.text.trim(),
        _passCtrl.text,
      );

      if (!mounted) return;

      if (result['status'] == 200) {
        _navigateByRole(result['data']['role']);
      } else {
        _showSnack(result['data']['message'] ?? 'Login failed', error: true);
      }
    } catch (e) {
      _showSnack('Connection error. Check your network.', error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleLogin() async {
    setState(() => _googleLoading = true);

    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        setState(() => _googleLoading = false);
        return;
      }

      final result = await AuthService.googleLogin(
        account.id,
        account.email,
        account.displayName ?? account.email,
      );

      if (!mounted) return;

      if (result['status'] == 200) {
        _navigateByRole(result['data']['role']);
      } else {
        _showSnack(result['data']['message'] ?? 'Google login failed', error: true);
      }
    } catch (e) {
      _showSnack('Google sign-in failed', error: true);
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  void _navigateByRole(String role) {
    final dest = role == 'admin'
        ? const AdminDashboardScreen()
        : const HomeScreen();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => dest),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDeep,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 52),
              _buildForm(),
              const SizedBox(height: 16),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: const [
          SizedBox(height: 40),
          Text(
            'Honkai Star',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              letterSpacing: 4,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'RETAIL',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 22,
              color: AppTheme.cyan,
              letterSpacing: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SIGN IN',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 14,
              color: AppTheme.cyan,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: AppTheme.divider),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.mail_outline),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,}$').hasMatch(v)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscure,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppTheme.textMuted,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.bgDeep,
                ),
              )
                  : const Text('LOGIN'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.textMuted.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: _googleLoading ? null : _googleLogin,
            child: _googleLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.cyan,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.g_mobiledata, color: AppTheme.textSecondary, size: 28),
                SizedBox(width: 8),
                Text(
                  'Continue with Google',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontFamily: 'Exo2',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Center(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterScreen()),
            ),
            child: RichText(
              text: const TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: AppTheme.textMuted, fontFamily: 'Exo2'),
                children: [
                  TextSpan(
                    text: 'Register',
                    style: TextStyle(
                      color: AppTheme.cyan,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Exo2',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}