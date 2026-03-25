class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? clubName;
  final String? createdAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.clubName,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      role: json['role'] as String,
      clubName: json['clubName'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'clubName': clubName,
      'createdAt': createdAt,
    };
  }

  String get fullName => '$firstName $lastName';
  bool get isClub => role == 'club';
  bool get isSpectator => role == 'spectator';
}
