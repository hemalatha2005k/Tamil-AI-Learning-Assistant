import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage.dart';

class ApiService {
  static const String baseUrl = "http://10.15.78.151:8080/api";

  // 🔥 COMMON AUTH HANDLER (IMPORTANT)
  static Future<http.Response> _requestWithAuth(
      Future<http.Response> Function(String token) request) async {

    String? token = await StorageService.getAccessToken();

    if (token == null) {
      throw Exception("No token found");
    }

    http.Response res = await request(token);

    // 🔥 TOKEN EXPIRED → REFRESH
    if (res.statusCode == 401) {
      final newToken = await _refreshToken();

      if (newToken == null) {
        throw Exception("Session expired, login again");
      }

      // 🔁 RETRY REQUEST
      res = await request(newToken);
    }

    return res;
  }

  // 🔄 REFRESH TOKEN
  static Future<String?> _refreshToken() async {
    final refreshToken = await StorageService.getRefreshToken();

    if (refreshToken == null) return null;

    final res = await http.post(
      Uri.parse("$baseUrl/auth/refresh"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(utf8.decode(res.bodyBytes));
      final newAccess = data["accessToken"];

      await StorageService.saveTokens(newAccess, refreshToken);

      return newAccess;
    }

    return null;
  }

  // 🔐 LOGIN
  static Future<Map<String, String>> login(
      String email, String password) async {

    final res = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(utf8.decode(res.bodyBytes));

    if (res.statusCode == 200 && data["accessToken"] != null) {
      return {
        "accessToken": data["accessToken"],
        "refreshToken": data["refreshToken"],
        "name": data["name"] ?? "",
        "email": data["email"] ?? "",
      };
    } else {
      throw Exception(data["error"] ?? data["message"] ?? "Login failed");
    }
  }

  // 📝 REGISTER
  static Future<void> register(
      String name, String email, String password) async {

    final res = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(utf8.decode(res.bodyBytes));

    if (res.statusCode != 200) {
      throw Exception(data["error"] ?? data["message"]);
    }
  }

  // 📩 SEND OTP
  static Future<void> sendOtp(String email) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/send-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to send OTP");
    }
  }

  // 🔁 RESEND OTP
  static Future<void> resendOtp(String email) async {
    await sendOtp(email);
  }

  // ✅ VERIFY OTP
  static Future<void> verifyOtp(String email, String otp) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    if (res.statusCode != 200) {
      throw Exception("Invalid OTP");
    }
  }

  // 🔄 RESET PASSWORD
  static Future<void> resetPassword(
      String email,
      String otp,
      String newPass,
      String confirmPass,
      ) async {

    final res = await http.post(
      Uri.parse("$baseUrl/auth/reset-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "otp": otp,
        "newPassword": newPass,
        "confirmPassword": confirmPass,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Reset failed");
    }
  }

  // 🔤 TRANSLATE
  static Future<String> translate(String text) async {
    final res = await _requestWithAuth((token) {
      return http.post(
        Uri.parse("$baseUrl/ai/translate"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"input_text": text}),
      );
    });

    final data = jsonDecode(utf8.decode(res.bodyBytes));
    return data["result"].toString();
  }

  // 🔁 REPHRASE
  static Future<List<String>> rephrase(String text) async {
    final res = await _requestWithAuth((token) {
      return http.post(
        Uri.parse("$baseUrl/ai/rephrase"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"input_text": text}),
      );
    });

    final data = jsonDecode(utf8.decode(res.bodyBytes));
    final result = data["result"];

    if (result is List) return List<String>.from(result);
    if (result["versions"] != null) {
      return List<String>.from(result["versions"]);
    }

    throw Exception("Rephrase failed");
  }

  // 🧠 SENTENCE
  static Future<List<String>> sentence(String input) async {
    final res = await _requestWithAuth((token) {
      return http.post(
        Uri.parse("$baseUrl/ai/sentence"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"input_text": input}),
      );
    });

    final data = jsonDecode(utf8.decode(res.bodyBytes));

    // ✅ FIXED: backend returns "result"
    if (data["result"] != null) {
      return List<String>.from(data["result"]);
    }

    throw Exception("Sentence generation failed");
  }

  // 📜 HISTORY
  static Future<List> getHistory() async {
    final res = await _requestWithAuth((token) {
      return http.get(
        Uri.parse("$baseUrl/ai/history"),
        headers: {"Authorization": "Bearer $token"},
      );
    });

    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  // ⭐ SAVED
  static Future<List> getSaved() async {
    final res = await _requestWithAuth((token) {
      return http.get(
        Uri.parse("$baseUrl/ai/saved"),
        headers: {"Authorization": "Bearer $token"},
      );
    });

    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  // ⭐ SAVE
  static Future<void> save(int id) async {
    await _requestWithAuth((token) {
      return http.post(
        Uri.parse("$baseUrl/ai/save/$id"),
        headers: {"Authorization": "Bearer $token"},
      );
    });
  }

  // ❌ UNSAVE
  static Future<void> unSave(int id) async {
    await _requestWithAuth((token) {
      return http.post(
        Uri.parse("$baseUrl/ai/unsave/$id"),
        headers: {"Authorization": "Bearer $token"},
      );
    });
  }

  // 🔐 CHANGE PASSWORD
  static Future<void> changePassword(
      String oldPass,
      String newPass,
      String confirmPass,
      ) async {

    await _requestWithAuth((token) {
      return http.post(
        Uri.parse("$baseUrl/ai/change-password"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "oldPassword": oldPass,
          "newPassword": newPass,
          "confirmPassword": confirmPass,
        }),
      );
    });
  }

  // 🚪 LOGOUT
  static Future<void> logout(String refreshToken) async {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/logout"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (res.statusCode != 200) {
      throw Exception("Logout failed");
    }
  }
}