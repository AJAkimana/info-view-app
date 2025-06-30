import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/service.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.130:5400/api/v1'; // Replace with actual proxy server URL
  static final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {'Content-Type': 'application/json'}));

  // Get list of available services
  static Future<List<Service>> getServices() async {
    try {
      final response = await _dio.get('/info-services');
      print ('Response: ${response.data}');
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
      final response = await _dio.post('/info-services/info', data: {
        'params': formData,
        'serviceId': serviceId
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
