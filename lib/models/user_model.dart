class UserModel {
  String username;
  String password;
  String phoneNumber;
  String address;
  String? profileImage; // Optional for profile picture

  UserModel({
    required this.username,
    required this.password,
    required this.phoneNumber,
    required this.address,
    this.profileImage,
  });

  // Copy constructor
  UserModel copyWith({
    String? username,
    String? password,
    String? phoneNumber,
    String? address,
    String? profileImage,
  }) {
    return UserModel(
      username: username ?? this.username,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}
