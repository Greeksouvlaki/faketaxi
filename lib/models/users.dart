class User {
  final int userId;
  final String? name;   // Use String? to indicate that this can be null
  final String? email;  // Use String? to indicate that this can be null
  final String? role;   // Use String? to indicate that this can be null

  User({
    required this.userId,
    this.name,   // Nullable field
    this.email,  // Nullable field
    this.role,   // Nullable field
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] as int,
      name: json['username'] as String?,   // Use as String? to handle null values
      email: json['email'] as String?,     // Use as String? to handle null values
      role: json['role'] as String?,       // Use as String? to handle null values
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': name,
      'email': email,
      'role': role,
    };
  }
}
