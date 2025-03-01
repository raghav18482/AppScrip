import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/signup_model.dart';
import '../services/common_services.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<AuthResponse?> registerUser(BuildContext context,String email, String password) async {
    Response? response;
    try {
      response = await _dio.post(
        '${CommonServices().baseurl}api/register',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return AuthResponse.fromJson(response.data);
    } on DioException catch (e) {
      if(response?.data['error']== 'Missing password'){
        CommonServices.showToast('Missing password', Colors.red);
      }
      if (e.response != null) {
        CommonServices.showToast('Error: ${e.response?.statusCode} - ${e.response?.data}', Colors.red);
        throw Exception('Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        CommonServices.showToast('Error: ${e.response?.statusCode} - ${e.response?.data}', Colors.red);
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<String> loginUser(BuildContext context,String email, String password) async {
    Response? response;
    try {
      response = await _dio.post(
        '${CommonServices().baseurl}api/login',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response.data['token'];
    } on DioException catch (e) {
      if(response?.data['error']== 'Missing password'){
        CommonServices.showToast('Missing password', Colors.red);
      }
      if (e.response != null) {
        CommonServices.showToast('Error: ${e.response?.statusCode} - ${e.response?.data}', Colors.red);
        throw Exception('Error: ${e.response?.statusCode} - ${e.response?.data}');
      } else {
        CommonServices.showToast('Error: ${e.response?.statusCode} - ${e.response?.data}', Colors.red);
        throw Exception('Network error: ${e.message}');
      }
    }
  }


}
