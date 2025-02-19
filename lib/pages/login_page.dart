import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../pages/home_page.dart';

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
            builder: (context) => HomePage(email: _emailController.text),
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
        final email = await _authService.getStoredUsername();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(email: email ?? ''),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loginWithCredentials,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    if (_isPasskeyAvailable) ...[
                      const SizedBox(height: 16),
                      const Text('or'),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _loginWithPasskey,
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Sign in with Passkey'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ],
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
