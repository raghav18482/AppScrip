class AuthResponse {
  final int id;
  final String token;

  AuthResponse({required this.id, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      id: json['id'],
      token: json['token'],
    );
  }
}