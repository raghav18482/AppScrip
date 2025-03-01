import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/common_services.dart';

class ProfileApiService {
  final Dio _dio = Dio();

  Future<ProfileModel?> fetchUserProfile(int userId) async {
    try {
      Response response = await _dio.get(
        '${CommonServices().baseurl}api/users',
        queryParameters: {'id': userId},
      );

      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      CommonServices.showToast('Failed to load profile: ${e.message}', Colors.red);
      throw Exception('Error: ${e.response?.statusCode} - ${e.response?.data}');
    }
  }

  Future<Map<String, dynamic>> fetchUsers(int page) async {
    try {
      final response = await _dio.get("${CommonServices().baseurl}api/users?page=$page");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load users");
      }
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }

}
