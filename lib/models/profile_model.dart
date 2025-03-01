class ProfileModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  ProfileModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['data']['id'],
      email: json['data']['email'],
      firstName: json['data']['first_name'],
      lastName: json['data']['last_name'],
      avatar: json['data']['avatar'],
    );
  }

  factory ProfileModel.fromJson2(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }

}
