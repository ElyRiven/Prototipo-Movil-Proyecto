class User {
  final int code;
  final String firstName;
  final String lastName;
  final String email;
  final String idNumber;
  final String phoneNumber;
  final String password;
  final int points;
  final int benSection;
  final DateTime firstLogin;
  final int role;

  User({
    required this.code,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.idNumber,
    required this.phoneNumber,
    required this.password,
    required this.points,
    required this.benSection,
    required this.firstLogin,
    required this.role,
  });
}
