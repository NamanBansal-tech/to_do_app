import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SharedPreferences {
  SharedPreferences._internal();

  static final SharedPreferences _instance = SharedPreferences._internal();

  static SharedPreferences get instance => _instance;

  final FlutterSecureStorage _flutterSecureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> saveDatabasePassword(String password) async {
    await _flutterSecureStorage.write(key: 'DatabsePassword', value: password);
  }

  Future<String?> getDatabasePassword() async {
    return await _flutterSecureStorage.read(key: 'DatabsePassword');
  }
}
