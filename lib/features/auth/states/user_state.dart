class UserState {
  final String username;
  final double annualExpense;

  UserState({
    required this.username,
    required this.annualExpense
  });

  factory UserState.initial() => UserState(
    username: '',
    annualExpense: 0,
  );

  UserState copyWith({
    String? username,
    double? annualExpense,
  }) {
    return UserState(
      username: username ?? this.username,
      annualExpense: annualExpense ?? this.annualExpense
    );
  }
}
