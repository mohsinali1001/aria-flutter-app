import '../data/app_database.dart';

class AuthState {
  final bool isLoading;
  final DbUser? user;
  final String? error;

  const AuthState({
    required this.isLoading,
    required this.user,
    this.error,
  });

  const AuthState.loading() : this(isLoading: true, user: null);
  const AuthState.unauthenticated() : this(isLoading: false, user: null);
  const AuthState.authenticated(DbUser user)
      : this(isLoading: false, user: user);

  bool get isAuthenticated => user != null;
}