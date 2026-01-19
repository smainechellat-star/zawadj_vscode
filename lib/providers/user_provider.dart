import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/partner_criteria_model.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  PartnerCriteria? _partnerCriteria;
  bool _profileComplete = false;

  User? get currentUser => _currentUser;
  PartnerCriteria? get partnerCriteria => _partnerCriteria;
  bool get isProfileComplete => _profileComplete;

  void setCurrentUser(User user) {
    _currentUser = user;
    _profileComplete = user.profileComplete;
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void setPartnerCriteria(PartnerCriteria criteria) {
    _partnerCriteria = criteria;
    notifyListeners();
  }

  void setProfileComplete(bool complete) {
    _profileComplete = complete;
    if (_currentUser != null) {
      _currentUser = User(
        uid: _currentUser!.uid,
        firstName: _currentUser!.firstName,
        email: _currentUser!.email,
        phoneNumber: _currentUser!.phoneNumber,
        age: _currentUser!.age,
        gender: _currentUser!.gender,
        country: _currentUser!.country,
        state: _currentUser!.state,
        maritalStatus: _currentUser!.maritalStatus,
        numberOfChildren: _currentUser!.numberOfChildren,
        childrenAgeRange: _currentUser!.childrenAgeRange,
        marriageIntent: _currentUser!.marriageIntent,
        educationLevel: _currentUser!.educationLevel,
        employmentStatus: _currentUser!.employmentStatus,
        housingType: _currentUser!.housingType,
        drinksAlcohol: _currentUser!.drinksAlcohol,
        smokes: _currentUser!.smokes,
        prayerStatus: _currentUser!.prayerStatus,
        wearGlasses: _currentUser!.wearGlasses,
        heightCm: _currentUser!.heightCm,
        skinColor: _currentUser!.skinColor,
        bodyType: _currentUser!.bodyType,
        profileImageUrl: _currentUser!.profileImageUrl,
        profileImageHidden: _currentUser!.profileImageHidden,
        profileComplete: complete,
        accountStatus: _currentUser!.accountStatus,
        partnerId: _currentUser!.partnerId,
        createdAt: _currentUser!.createdAt,
        lastUpdated: DateTime.now(),
        viewedBy: _currentUser!.viewedBy,
      );
    }
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    _partnerCriteria = null;
    _profileComplete = false;
    notifyListeners();
  }
}
