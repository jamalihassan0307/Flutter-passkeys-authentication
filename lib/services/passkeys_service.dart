// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:passkeys_android/passkeys_android.dart';
// import 'package:passkeys_platform_interface/types/types.dart';
// import 'dart:convert';
// import 'dart:math';

// class PasskeysService {
//   final _passkeys = PasskeysAndroid();
//   static const String rpId = 'com.example.flutter_application_1';
//   static const String rpName = 'Passkeys Demo';

//   String _generateChallenge() {
//     // Generate a 32-byte random challenge
//     final random = Random.secure();
//     final values = List<int>.generate(32, (_) => random.nextInt(256));
//     return base64Url.encode(values).replaceAll('=', ''); // Remove padding
//   }

//   Future<bool> isAvailable() async {
//     try {
//       debugPrint('Checking passkey availability...');
//       final availability = await _passkeys.getAvailability();
//       debugPrint(
//           'Passkey availability result: ${availability.hasPasskeySupport}');
//       return availability.hasPasskeySupport;
//     } catch (e, stackTrace) {
//       debugPrint('Error checking passkey availability: $e\n$stackTrace');
//       return false;
//     }
//   }

//   Future<void> createPasskey({required String username}) async {
//     try {
//       debugPrint('Creating passkey for user: $username');

//       final request = RegisterRequestType(
//         challenge: _generateChallenge(),
//         relyingParty: RelyingPartyType(
//           id: rpId,
//           name: rpName,
//         ),
//         user: UserType(
//           id: 'demo-user-123456789',
//           name: username,
//           displayName: username,
//         ),
//         authSelectionType: AuthenticatorSelectionType(
//           authenticatorAttachment: 'platform',
//           requireResidentKey: true,
//           residentKey: 'required',
//           userVerification: 'required',
//         ),
//         timeout: 120000,
//         attestation: 'none',
//         excludeCredentials: [],
//       );

//       final response = await _passkeys.register(request);
//       debugPrint('Passkey created successfully: ${response.toString()}');
//     } catch (e, stackTrace) {
//       debugPrint('Error creating passkey: $e\n$stackTrace');
//       rethrow;
//     }
//   }

//   Future<void> getPasskey(context) async {
//     try {
//       debugPrint('Getting passkey for rpId: $rpId');

//       final request = AuthenticateRequestType(
//         challenge: _generateChallenge(),
//         relyingPartyId: rpId,
//         mediation: MediationType.Required,
//         timeout: 60000,
//         userVerification: 'discouraged',
//         allowCredentials: [],
//         preferImmediatelyAvailableCredentials: true,
//       );

//       final response = await _passkeys.authenticate(request);
//       debugPrint('Passkey authentication successful: ${response.toString()}');
//     } catch (e, stackTrace) {
//       if (e.toString().contains('Cannot find a matching credential')) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Please create a passkey first before signing in')),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error getting passkey: $e')),
//         );
//       }
//       debugPrint('Error getting passkey: $e\n$stackTrace');
//       rethrow;
//     }
//   }
// }
