import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/signup_model.dart';
import '../repositories/auth_repository.dart';
import '../services/cache.dart';


class AuthProvider extends ChangeNotifier {
  final TextEditingController usernameSignupController = TextEditingController();
  final TextEditingController passwordSignupController = TextEditingController();

  final TextEditingController usernameLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();

  bool passwordVisible = false;

  void visibility(bool pass){
    passwordVisible = !pass;
    notifyListeners();
  }

  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _error;
  String? _token;
  int id =0;
  AuthResponse? _authResponse;

  bool get isLoading => _isLoading;
  String? get error => _error;
  // AuthResponse? get authResponse => _authResponse;
  // String? get token => _token;

  Future<void> signup(BuildContext context,String username,String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _authResponse = await _authService.registerUser(context,username, password);
      Navigator.pop(context);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _saveUserId(_authResponse!.token,_authResponse!.id.toString());
      notifyListeners();
    }
  }

  Future<String?> login(BuildContext context,String username,String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.loginUser(context,username, password).then((token){
        _token = token;
        _saveToken(token);
      });
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      if (_token == null) {
        print("Token is null");
      }
      _getId(_token!).then((userId) {
        id = userId;
      });
      print('id=>$id');
      notifyListeners();
      return _token;
    }
  }

  Future<void> _saveUserId(String token,String id) async {
    Cache().addSharedprefs(token, id);
  }

  Future<int> _getId(String token) async {
    String? userid = await Cache().getsharedprefs(token);
    return int.tryParse(userid ?? '0')!;
  }

  /// Save token to SharedPreferences
  Future<void> _saveToken(String token) async {
    Cache().addSharedprefs('auth_token', token);
  }

  /// Retrieve token from SharedPreferences
  Future<String?> getToken() async {
    _token = await Cache().getsharedprefs('auth_token');
    return _token;
  }

  /// Logout and clear session
  Future<void> logout(context) async {
     Cache().removetoSharedprefs('auth_token');
     Navigator.pushNamed(context, '/login');
  }

}