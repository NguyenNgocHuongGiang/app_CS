import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricAuth {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    bool canCheckBiometrics = await _auth.canCheckBiometrics;
    bool isDeviceSupported = await _auth.isDeviceSupported();

    if (canCheckBiometrics || isDeviceSupported) {
      try {
        return await _auth.authenticate(
          localizedReason: 'Vui lòng quét vân tay để đăng nhập',
          options: AuthenticationOptions(
            biometricOnly: true, 
            stickyAuth: true,
          ),
        );
      } on PlatformException catch (e) {
        print("Lỗi xác thực vân tay: $e");
      }
    }
    return false;
  }

   Future<Map<String, String>?> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }
}
