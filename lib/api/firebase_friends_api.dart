import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_auth_api.dart';


class FirebaseFriendsApi {
  final FirebaseFirestore db = FirebaseFirestore.instance; // initializing firebase firestore instance

  Stream<QuerySnapshot> getAllFriends() {
    return db.collection("friends").snapshots(); // getting all the friends using the snapshots in the firebase
  }

  Future<DocumentReference> addFriend(Map<String, dynamic> friend) async { // adding a friend under the user signed in
    return db.collection("users").doc(FirebaseAuthApi().getUser()!.uid).collection("friends").add(friend);
  } 

  Future<String> deleteFriend(String id) async { // deleting a friend under the user signed in
    try {
      await db.collection("users").doc(FirebaseAuthApi().getUser()!.uid).collection("friends").doc(id).delete();
      return "Successfully deleted friend!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<String> updateFriend(String id, Map<String, dynamic> updatedData) async { // updating a friend under the user signed in
    try {
      await db.collection("users").doc(FirebaseAuthApi().getUser()!.uid).collection("friends").doc(id).update(updatedData);
      return "Successfully edited friend!";
    } on FirebaseException catch (e) {
      return "Failed with error ${e.code}";
    }
  }

  Future<QuerySnapshot> fetchFriends() async { //getting all the friends under the user signed in 
    return await db.collection("users").doc(FirebaseAuthApi().getUser()!.uid).collection('friends').get();
  } 


}
