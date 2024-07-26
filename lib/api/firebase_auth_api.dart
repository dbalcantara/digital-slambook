import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthApi {
  // Initializations for the Firebase, GoogleSignIn, FirebaseFirestore instances
  final FirebaseAuth auth = FirebaseAuth.instance;                            
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // stream for getting the user's authentication changes 
  Stream<User?> getUserStream() {
    return auth.authStateChanges();
  }

  // method for getting the current user
  User? getUser() {
    return auth.currentUser;
  }

  // signing in with email and password from getting the username of the user 
  Future<String> signInWithEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Successfully signed in!";
    } on FirebaseAuthException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> signInWithUsernameAndPassword(String username, String password) async {
    try {
      // gets the email associated with the username
      var userDoc = await firestore.collection('users').where('username', isEqualTo: username).limit(1).get();
      if (userDoc.docs.isEmpty) {
        return "Username not found";
      }
      
      String email = userDoc.docs.first['email'];
      
      // sign in with email and password
      return await signInWithEmailAndPassword(email, password);
    } catch (e) {
      return "Failed with error ${e.toString()}";
    }
  }
  //initialize the required variables for signing up
  Future<String> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
    required List<String> contactNumbers,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // store additional user information in Firestore
      await firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'username': username,
        'email': email,
        'contactNumbers': contactNumbers,
      });

      return "Successfully signed up!";
    } on FirebaseAuthException catch (e) {
      return "Failed with error ${e.code}";
    }
  }
  // for signing out 
  Future<void> signOut() async {
      await auth.signOut();
    await googleSignIn.signOut();
  }

  // for signing in with google 
  Future<User?> signInWithGoogle() async {
    final googleAccount = await googleSignIn.signIn();
    final googleAuth = await  googleAccount?.authentication;
    final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,);
    final UserCredential  = await FirebaseAuth.instance.signInWithCredential(credential);
      return null;   
}
}
