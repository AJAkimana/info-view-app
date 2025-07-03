import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoUtil {
  static Future<Map<String, dynamic>> getReqInfo() async {
    String ipAddress = '';
    String city = '';
    String country = '';
    String deviceType = '';

    try {
      // Get IP and location
      final ipRes = await http.get(Uri.parse('http://ip-api.com/json/'));
      if (ipRes.statusCode == 200) {
        final ipJson = json.decode(ipRes.body);
        ipAddress = ipJson['query'] ?? '';
        city = ipJson['city'] ?? '';
        country = ipJson['country'] ?? '';
      }
    } catch (_) {}

    try {
      final deviceInfo = DeviceInfoPlugin();
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceType = androidInfo.model ?? '';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceType = iosInfo.utsname.machine ?? '';
      }
    } catch (_) {}

    return {
      'ipAddress': ipAddress,
      'deviceType': deviceType,
      'city': '$city, $country',
    };
  }
}