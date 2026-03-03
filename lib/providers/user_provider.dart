import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  UserProvider() {
    _loadUser();
  }

  void _loadUser() {
    _user = AuthService.instance.currentUser;
    notifyListeners();
  }

  void reloadUser() {
    _loadUser();
  }


  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.instance.signOut();
    _user = null;
    notifyListeners();
  }
}
