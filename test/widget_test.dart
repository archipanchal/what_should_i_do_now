import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:what_should_i_do_now/main.dart';
import 'package:what_should_i_do_now/home_screen.dart';
import 'package:what_should_i_do_now/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:what_should_i_do_now/providers/theme_provider.dart';
import 'package:what_should_i_do_now/providers/user_provider.dart';

// Mock Implementation
class MockUser extends Mock implements User {
  @override
  String get uid => 'test_uid';
  
  @override
  Future<void> updateDisplayName(String? displayName) async {}
}

class MockUserCredential extends Mock implements UserCredential {
  @override
  User? get user => MockUser();
}

class MockAuthService extends AuthService {
  User? _currentUser;
  final _authStateController = StreamController<User?>.broadcast();

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (password == "password123") {
       _currentUser = MockUser();
       _authStateController.add(_currentUser);
       return MockUserCredential();
    } else {
      throw FirebaseAuthException(code: 'wrong-password', message: 'Wrong password provided');
    }
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _currentUser = MockUser();
    _authStateController.add(_currentUser);
    return MockUserCredential();
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 50));
    _currentUser = null;
    _authStateController.add(null);
  }
  
  @override
  Future<void> updateDisplayName(String name) async {}
}

void main() {
  setUp(() {
    // Inject Mock Service before app starts
    AuthService.init(MockAuthService());
  });

  testWidgets('Full Auth Flow Integration Test', (WidgetTester tester) async {
    // 1. Start App (Logged Out)
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Splash Screen
    expect(find.text('What Should I Do Now?'), findsOneWidget);
    // Splash screen automatically navigates after delay in the real app,
    // but in test environment without pumpAndSettle enough times or mocking time, it might stay.
    // However, the original test logic might expect it to stay or move.
    // The splash screen in main.dart now waits 2 seconds.
    
    await tester.pump(const Duration(seconds: 3)); // Wait for splash
    await tester.pumpAndSettle(); // Settle navigation

    // Should be at Login Screen (since mock user starts null)
    expect(find.text('Login'), findsWidgets);

    // 3. Go to Register
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();
    expect(find.text('Register'), findsWidgets);
    expect(find.text('Confirm Password'), findsOneWidget);

    // 4. Fill Registration Form
    await tester.enterText(find.ancestor(of: find.text('Full Name'), matching: find.byType(TextField)), 'Test User');
    await tester.enterText(find.ancestor(of: find.text('Email'), matching: find.byType(TextField)), 'test@example.com');
    await tester.enterText(find.ancestor(of: find.text('Password'), matching: find.byType(TextField)), 'password123');
    await tester.enterText(find.ancestor(of: find.text('Confirm Password'), matching: find.byType(TextField)), 'password123');
    
    // Tap Register
    await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
    await tester.pumpAndSettle(); // Wait for Future.delayed and navigation

    // 5. Verify Home Screen (Logged In)
    expect(find.byType(HomeScreen), findsOneWidget);
    // expect(find.text('Suggest Activity'), findsOneWidget); // Depends on Home body

    // 6. Logout
    // Need to open drawer to find logout if it's in drawer now?
    // In Lab 7 and 8, Logout is in Drawer usually or Home.
    // In current HomeScreen code (Lab 8), Logout is in the Drawer.
    
    // Open Drawer
    await tester.tap(find.byIcon(Icons.menu)); // Assuming default drawer icon
    await tester.pumpAndSettle();

    // Find Logout in Drawer
    await tester.tap(find.text('Logout')); // This opens dialog
    await tester.pumpAndSettle();
    
    // Verify Dialog
    expect(find.text('Are you sure you want to logout?'), findsOneWidget);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Logout')); // Click logout in dialog
    await tester.pumpAndSettle();

    // 7. Verify back to Login Screen
    expect(find.text('Login'), findsWidgets);
  });
}
