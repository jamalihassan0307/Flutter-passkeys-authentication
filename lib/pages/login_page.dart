import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../pages/home_page.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasskeyAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkPasskeyAvailability();
  }

  Future<void> _checkPasskeyAvailability() async {
    final isAvailable = await _authService.isAvailable();
    if (mounted) {
      setState(() {
        _isPasskeyAvailable = isAvailable;
      });
    }
  }

  void _showPasskeyDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Save Login with Passkey?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Next time, you can sign in quickly and securely using your device biometrics.',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Skip'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _registerPasskey();
                  },
                  child: const Text('Save Passkey'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerPasskey() async {
    setState(() => _isLoading = true);
    try {
      final result = await _authService.register(
        username: _emailController.text,
      );
      if (result && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithPasskey() async {
    setState(() => _isLoading = true);
    try {
      final result = await _authService.authenticate(context);
      if (result && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } catch (e, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error authenticating: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithCredentials() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    // Simulate login delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    if (mounted) {
      _showPasskeyDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/passkey.jpeg',
                height: 120,
              ),
              const SizedBox(height: 40),
              Text(
                'Secure Authentication',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Use your biometric or security key to sign in securely',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: _loginWithPasskey,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Sign in with PassKey'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _loginWithCredentials,
                child: const Text('Use alternative sign-in method'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
