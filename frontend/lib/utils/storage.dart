import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {

  static const storage = FlutterSecureStorage();

  // 🔐 SAVE TOKENS
  static Future<void> saveTokens(String access, String refresh) async {
    await storage.write(key: "accessToken", value: access);
    await storage.write(key: "refreshToken", value: refresh);
  }

  // 🔍 GET ACCESS TOKEN
  static Future<String?> getAccessToken() async {
    return await storage.read(key: "accessToken");
  }

  // 🔥 ALIAS (FOR OLD CODE)
  static Future<String?> getToken() async {
    return await getAccessToken();
  }

  // 🔍 GET REFRESH TOKEN
  static Future<String?> getRefreshToken() async {
    return await storage.read(key: "refreshToken");
  }

  // 👤 SAVE USER DATA ✅ (NEW)
  static Future<void> saveUser(String name, String email) async {
    await storage.write(key: "name", value: name);
    await storage.write(key: "email", value: email);
  }

  // 👤 GET NAME ✅ (FIX)
  static Future<String?> getName() async {
    return await storage.read(key: "name");
  }

  // 👤 GET EMAIL ✅ (FIX)
  static Future<String?> getEmail() async {
    return await storage.read(key: "email");
  }

  // ❌ CLEAR ALL (LOGOUT)
  static Future<void> clearTokens() async {
    await storage.deleteAll(); // 🔥 better than deleting one by one
  }
}