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

      bool isAuthenticated = false;

      if (isBiometricSupported && canCheckBiometrics) {
        isAuthenticated = await localAuthentication.authenticate(
          localizedReason: 'Varify Fingerprint.',
          options: AuthenticationOptions(biometricOnly: true),
        );
        print('AUTHENTICATION$isAuthenticated');
      }
      return isAuthenticated;
    } catch (e) {
      print(e);
    }
    throw Exception('AUTHENTICATION FAILED');
  }

  // authenticatedOrNot() async {
  //   final isAuth = await authenticateWithFingerprint();
  //   setState(() {
  //     isAuthenticated = isAuth;
  //     print(isAuthenticated);
  //   });
  // }

  @override
  void initState() {
    super.initState();
    authenticateWithFingerprint();
    // authenticatedOrNot();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Dashboard()));
          }),
      appBar: AppBar(
        title: Text('LOGIN'),
      ),
    );
  }
}
