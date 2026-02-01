import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  static AuthService? _instance;
  static AuthService get instance {
    if (_instance == null) {
      throw Exception("AuthService not initialized. Call init() first.");
    }
    return _instance!;
  }

  static void init(AuthService service) {
    _instance = service;
  }

  User? get currentUser;
  Stream<User?> get authStateChanges;

  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password});
  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password});
  Future<void> signOut();
  Future<void> updateDisplayName(String name);
}

class FirebaseAuthService extends AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() {
    return _auth.signOut();
  }

  @override
  Future<void> updateDisplayName(String name) async {
    await _auth.currentUser?.updateDisplayName(name);
  }
}
