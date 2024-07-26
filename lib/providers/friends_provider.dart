  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import '../api/firebase_friends_api.dart';

  class FriendsProvider extends ChangeNotifier {
    final FirebaseFriendsApi _firebaseFriendsApi = FirebaseFriendsApi();
    final List<Map<String, dynamic>> _friends = [];
    Map<String, dynamic> _currentUser = {};

    List<Map<String, dynamic>> get friends => _friends;
    Map<String, dynamic> get currentUser => _currentUser;

    FriendsProvider() {
      _fetchFriends();
    }

    Future<void> _fetchFriends() async {
      final QuerySnapshot snapshot = await _firebaseFriendsApi.fetchFriends();
      for (var doc in snapshot.docs) {
        final friendsData = doc.data() as Map<String, dynamic>;
        friendsData['id'] = doc.id;
        _friends.add(friendsData);
      }
      notifyListeners();
    }

    Stream<QuerySnapshot> getAllFriends() {
      return _firebaseFriendsApi.getAllFriends();
    }

    void addFriend(Map<String, dynamic> friendData) async {
      final DocumentReference docRef = await _firebaseFriendsApi.addFriend(friendData);
      final id = docRef.id;
      _friends.add({'id': id, ...friendData});
      notifyListeners();
      print('Successfully added friend!');
    }

    Future<void> deleteFriend(String id) async {
      String message = await _firebaseFriendsApi.deleteFriend(id);
      _friends.removeWhere((friend) => friend['id'] == id);
      print(message);
      notifyListeners();
    }

    Future<void> updateFriend(String id, Map<String, dynamic> friendData) async {
      String message = await _firebaseFriendsApi.updateFriend(id, friendData);
      final index = _friends.indexWhere((friend) => friend['id'] == id);
      _friends[index] = {..._friends[index], ...friendData};
      print(message);
      notifyListeners();
    }

    // void updateCurrentUser(Map<String, dynamic> userData) {
    //   _currentUser = userData;
    //   notifyListeners();
    // }

    // Future<void> fetchUserData() async {
    //   final QuerySnapshot snapshot = await _firebaseFriendsApi.fetchUserData();
    //   for (var doc in snapshot.docs) {
    //     final currentUser = doc.data() as Map<String, dynamic>;
    //     currentUser['id'] = doc.id;
    //     _currentUser = currentUser;  // Correctly update _currentUser
    //   }
    //   notifyListeners();
    // }

    // Future<void> saveUserData(Map<String, dynamic> userData) async {
    //   final DocumentReference docRef = await _firebaseFriendsApi.saveUserData(userData);
    //   final id = docRef.id;
    //   _currentUser = {'id': id, ...userData}; // Update _currentUser with new data and id
    //   notifyListeners();
    // }

    // Future<void> updateUser(String id, Map<String, dynamic> userData) async {
    //   String message = await _firebaseFriendsApi.updateUser(id, userData);
    //   if (_currentUser['id'] == id) {
    //     _currentUser = {'id': id, ...userData}; // Update _currentUser with new data and id
    //   }
    //   print(message);
    //   notifyListeners();
    // }

  }
