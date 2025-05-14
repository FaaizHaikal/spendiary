class User {
  final String username;
  final double annualSaving;

  User({required this.username, required this.annualSaving});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(username: json['Username'], annualSaving: (json['AnnualSaving'] as num).toDouble());
  }
}
