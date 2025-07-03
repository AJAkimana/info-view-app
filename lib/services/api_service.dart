import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:info_viewer/utils/device_info_util.dart';
import '../models/service.dart';

class ApiService {
  static const String baseUrl = 'https://dev.akimanaja.com/api/v1'; // Replace with actual proxy server URL
  static final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {'Content-Type': 'application/json'}));

  // Get list of available services
  static Future<List<Service>> getServices() async {
    try {
      final response = await _dio.get('/info-services');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((serviceJson) => Service.fromJson(serviceJson)).toList();
      } else {
        throw Exception('Failed to load services: \\${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Network error: $e');
    }
  }

  // Submit form data for a service
  static Future<Map<String, dynamic>> submitServiceData(
    String serviceId,
    Map<String, dynamic> formData,
  ) async {
    try {
      final reqInfo = await DeviceInfoUtil.getReqInfo();
      final response = await _dio.post('/info-services/info', data: {
        'params': formData,
        'serviceId': serviceId,
        'reqInfo': reqInfo,
      });
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to submit data: \\${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get service data/information
  static Future<Map<String, dynamic>> getServiceData(String serviceId) async {
    try {
      final response = await _dio.get('/info-services/$serviceId');
      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw Exception('Failed to get service data: \\${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
