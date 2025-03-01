import 'package:flutter/material.dart';

import '../models/profile_model.dart';
import '../repositories/profile_repository.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileApiService _apiService = ProfileApiService();
  ProfileModel? _profile;
  List<ProfileModel> _users = [];
  bool isLoading = false;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;

  ProfileModel? get profile => _profile;
  List<ProfileModel> get users => _users;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;

  Future<void> loadProfile(int userId) async {
    _error = null;
    notifyListeners();

    try {
      _profile = await _apiService.fetchUserProfile(userId);

    } catch (e) {
      _error = e.toString();
    }

    notifyListeners();
  }

  Future<void> fetchUsers(int page) async {
    if (page > _totalPages) return;
    try {
      final data = await _apiService.fetchUsers(page);
      List<ProfileModel> newUsers = (data['data'] as List)
          .map((json) => ProfileModel.fromJson2(json))
          .toList();

      _users.addAll(newUsers);
      _currentPage = data['page'];
      _totalPages = data['total_pages'];// Update total pages
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

}
