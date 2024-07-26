import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:week8datapersistence/api/firebase_auth_api.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthApi authService;           
  late Stream<User?> userStream;
  User? user;

  UserAuthProvider() {
    authService = FirebaseAuthApi();
    userStream = authService.getUserStream();
    userStream.listen((user) {
      this.user = user;
      notifyListeners();
    });
  }

  Future<String> signIn({required String username, required String password}) async {
    String message = await authService.signInWithUsernameAndPassword(username, password);
    notifyListeners();
    return message;
  }

  Future<String> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
    required List<String> contactNumbers,
  }) async {
    String message = await authService.signUp(
      name: name,
      username: username,
      email: email,
      password: password,
      contactNumbers: contactNumbers,
    );
    notifyListeners();
    return message;
  }

  Future<void> signOut() async {
    await authService.signOut();
    notifyListeners();
  }

  Future<User?> signInWithGoogle() async {
    final user = await authService.signInWithGoogle();
    if (user != null) {
      this.user = user;
      notifyListeners();
    }
    return user;
  }
}
