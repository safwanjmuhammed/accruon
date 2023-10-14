import 'package:accruon/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAuthenticated = false;
  Future<bool> authenticateWithFingerprint() async {
    try {
      final LocalAuthentication localAuthentication = LocalAuthentication();
      bool isBiometricSupported = await localAuthentication.isDeviceSupported();
      print('BIOOOOMETRICS SUPPORTED?$isBiometricSupported');
      bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
      print('CANCHECKBIOMETRICS SUPPORTED?$isBiometricSupported');

      isAuthenticated = false;

      if (isBiometricSupported && canCheckBiometrics) {
        isAuthenticated = await localAuthentication.authenticate(
          localizedReason: 'Varify Fingerprint.',
          options: AuthenticationOptions(biometricOnly: true),
        );
        if (isAuthenticated) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        }
        return isAuthenticated;
      }
    } catch (e) {
      print(e);
    }
    return isAuthenticated;
    // throw Exception('AUTHENTICATION FAILED');
  }

  @override
  void initState() {
    super.initState();
    authenticateWithFingerprint();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.camera), onPressed: () {}),
      appBar: AppBar(
        title: Text('LOGIN'),
      ),
    );
  }
}
