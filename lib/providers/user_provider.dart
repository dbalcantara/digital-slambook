  import 'package:flutter/material.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import '../api/firebase_user_api.dart';

  class ProfileProvider extends ChangeNotifier {
    final FirebaseProfileApi _firebaseProfileApi = FirebaseProfileApi();
    final List<Map<String, dynamic>> _profile = [];

    List<Map<String, dynamic>> get profile => _profile;

    ProfileProvider() {
      _fetchProfile();
    }

    Future<void> _fetchProfile() async {
      final QuerySnapshot snapshot = await _firebaseProfileApi.fetchProfile();
      for (var doc in snapshot.docs) {
        final profileData = doc.data() as Map<String, dynamic>;
        profileData['id'] = doc.id;
        _profile.add(profileData);
      }
      notifyListeners();
    }

    Stream<QuerySnapshot> getAllProfile() {
      return _firebaseProfileApi.getAllProfile();
    }

    void addProfile(Map<String, dynamic> profileData) async {
      final DocumentReference docRef = await _firebaseProfileApi.addProfile(profileData);
      final id = docRef.id;
      _profile.add({'id': id, ...profileData});
      notifyListeners();
      print('Successfully added profile!');
    }

    Future<void> deleteProfile(String id) async {
      String message = await _firebaseProfileApi.deleteProfile(id);
      _profile.removeWhere((profile) => profile['id'] == id);
      print(message);
      notifyListeners();
    }

    Future<void> updateProfile(String id, Map<String, dynamic> profileData) async {
      String message = await _firebaseProfileApi.updateProfile(id, profileData);
      final index = _profile.indexWhere((profile) => profile['id'] == id);
      _profile[index] = {..._profile[index], ...profileData};
      print(message);
      notifyListeners();
    }


  }
