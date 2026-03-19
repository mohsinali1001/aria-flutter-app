import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../data/app_database.dart';
import 'auth_state.dart';

const _prefsUserIdKey = 'auth.currentUserId';

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required AppDatabase db,
    required SharedPreferences prefs,
  })  : _db = db,
        _prefs = prefs,
        super(const AuthState.loading()) {
    _init();
  }

  final AppDatabase _db;
  final SharedPreferences _prefs;
  static const _uuid = Uuid();

  Future<void> _init() async {
    final id = _prefs.getInt(_prefsUserIdKey);
    if (id == null) {
      state = const AuthState.unauthenticated();
      return;
    }
    final user = await _db.getUserById(id);
    if (user == null) {
      await _prefs.remove(_prefsUserIdKey);
      state = const AuthState.unauthenticated();
      return;
    }
    state = AuthState.authenticated(user);
  }

  static String _hashPassword({
    required String password,
    required String salt,
  }) {
    final bytes = utf8.encode('$salt::$password');
    return sha256.convert(bytes).toString();
  }

  static String _newSalt() => _uuid.v4();

  // ── Firebase Sync ──────────────────────────────────────────────────
  Future<void> syncFromFirebase({
    required String id,
    required String email,
    required String name,
  }) async {
    try {
      final normalizedEmail = email.trim().toLowerCase();

      // Check if user already exists in local DB
      DbUser? user = await _db.getUserByEmail(normalizedEmail);

      if (user == null) {
        // First time Firebase login — create local record
        await _db.createUser(
          name: name.trim().isEmpty
              ? email.split('@').first
              : name.trim(),
          email: normalizedEmail,
          passwordHash: 'firebase_auth',
          passwordSalt: 'firebase_auth',
        );
        user = await _db.getUserByEmail(normalizedEmail);
      }

      if (user != null) {
        await _prefs.setInt(_prefsUserIdKey, user.id);
        state = AuthState.authenticated(user);
      }
    } catch (e) {
      state = AuthState(isLoading: false, user: null, error: e.toString());
    }
  }

  // ── Sign Out ───────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _prefs.remove(_prefsUserIdKey);
    state = const AuthState.unauthenticated();
  }

  // ── Email Register ─────────────────────────────────────────────────
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final existing = await _db.getUserByEmail(normalizedEmail);
      if (existing != null) {
        state = const AuthState(
            isLoading: false, user: null,
            error: 'Email already registered');
        return false;
      }
      final salt = _newSalt();
      final hash = _hashPassword(password: password, salt: salt);
      await _db.createUser(
        name: name.trim(),
        email: normalizedEmail,
        passwordHash: hash,
        passwordSalt: salt,
      );
      state = const AuthState.unauthenticated();
      return true;
    } catch (e) {
      state = AuthState(isLoading: false, user: null, error: e.toString());
      return false;
    }
  }

  // ── Email Login ────────────────────────────────────────────────────
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final normalizedEmail = email.trim().toLowerCase();
      final user = await _db.getUserByEmail(normalizedEmail);
      if (user == null) {
        state = const AuthState(
            isLoading: false, user: null,
            error: 'Invalid email or password');
        return false;
      }
      final hash = _hashPassword(password: password, salt: user.passwordSalt);
      if (hash != user.passwordHash) {
        state = const AuthState(
            isLoading: false, user: null,
            error: 'Invalid email or password');
        return false;
      }
      await _prefs.setInt(_prefsUserIdKey, user.id);
      state = AuthState.authenticated(user);
      return true;
    } catch (e) {
      state = AuthState(isLoading: false, user: null, error: e.toString());
      return false;
    }
  }

  // ── Update Profile ─────────────────────────────────────────────────
  Future<bool> updateProfile({
    required String name,
    required String email,
  }) async {
    final current = state.user;
    if (current == null) return false;
    final ok = await _db.updateUserProfile(
      id: current.id,
      name: name,
      email: email,
    );
    if (!ok) return false;
    final refreshed = await _db.getUserById(current.id);
    if (refreshed == null) return false;
    state = AuthState.authenticated(refreshed);
    return true;
  }

  // ── Logout (kept for compatibility) ───────────────────────────────
  Future<void> logout() async {
    await _prefs.remove(_prefsUserIdKey);
    state = const AuthState.unauthenticated();
  }
}