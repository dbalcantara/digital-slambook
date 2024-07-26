import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_auth_api.dart';

// same implementations with the FirebaseFriendsApi but for the user profile
class FirebaseProfileApi {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getAllProfile() {
    return db.collection("profile").snapshots();
  }

  Future<DocumentReference> addProfile(Map<String, dynamic> profile) async {
    return db.collection("users").doc(FirebaseAuthApi().getUser()!.uid).collection("profile").add(profile);
  } 

  Future<String> deleteProfile(String id) async {
    try {
      await db.collection("users").doc(FirebaseAuthApi().getUser()!.uid).collection("profile").doc(id).delete();
      return "Successfully deleted profile!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> updateProfile(String id, Map<String, dynamic> updatedData) async {
    try {
      await db.collection("users").doc(FirebaseAuthApi().getUser()!.uid).collection("profile").doc(id).update(updatedData);
      return "Successfully edited profile!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<QuerySnapshot> fetchProfile() async {
    return await db.collection("users").doc(FirebaseAuthApi().getUser()!.uid).collection('profile').get();
  } 
}
