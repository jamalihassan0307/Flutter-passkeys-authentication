import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final LocalAuthentication _auth = LocalAuthentication();
  final _storage = const FlutterSecureStorage();

  Future<bool> isAvailable() async {
    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  Future<bool> register({required String username}) async {
    try {
      final authenticated = await _auth.authenticate(
        localizedReason: 'Register your biometric credentials',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        // Store the username securely
        await _storage.write(key: 'registered_user', value: username);
        return true;
      }
      return false;
    } on PlatformException catch (e) {
      print('Error registering: $e');
      return false;
    }
  }

  Future<bool> authenticate(context) async {
    try {
      final username = await _storage.read(key: 'registered_user');
      if (username == null) {
        throw Exception('No registered user found');
      }

      // Print the stored username
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Stored username: $username')));

      return await _auth.authenticate(
        localizedReason: 'Authenticate to sign in',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print('Error authenticating: $e');
      return false;
    }
  }

  Future<String?> getStoredUsername() async {
    return await _storage.read(key: 'registered_user');
  }
}
