class Admin {
  final String email;
  final String password;

  Admin({required this.email, required this.password});

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      email: json['email'],
      password: json['password'],
    );
  }
}
