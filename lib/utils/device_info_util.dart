import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

// Set default values
class DeviceInfoUtil {
  static final initials = {
    'ipAddress': '127.0.0.1',
    'deviceType': 'Unknown Device',
    'city': 'Kigali, Rwanda',
    'country': 'Rwanda',
  };
  static Future<Map<String, dynamic>> getReqInfo() async {
    String ipAddress = initials['ipAddress']!;
    String city = initials['city']!;
    String country = initials['country']!;
    String deviceType = initials['deviceType']!;

    try {
      // Get IP and location
      final ipRes = await http.get(Uri.parse('http://ip-api.com/json/'));
      if (ipRes.statusCode == 200) {
        final ipJson = json.decode(ipRes.body);
        ipAddress = ipJson['query'] ?? initials['ipAddress']!;
        city = ipJson['city'] ?? initials['city']!;
        country = ipJson['country'] ?? initials['country']!;
      }
    } catch (_) {}

    try {
      final deviceInfo = DeviceInfoPlugin();
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceType = androidInfo.model;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceType = iosInfo.utsname.machine;
      }
    } catch (_) {}

    return {
      'ipAddress': ipAddress,
      'deviceType': deviceType,
      'city': '$city, $country',
    };
  }
}