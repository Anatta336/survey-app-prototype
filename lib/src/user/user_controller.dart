import 'package:flutter/foundation.dart';

enum UserType {
  surveyor,
  engineer,
}

/// A controller that manages user data and notifies listeners of changes.
class UserController extends ChangeNotifier {
  int _userId;
  UserType _userType;

  /// Creates a new [UserController] with the given user ID and type.
  UserController({
    int userId = 0,
    UserType userType = UserType.surveyor,
  })  : _userId = userId,
        _userType = userType;

  int get userId => _userId;

  UserType get userType => _userType;

  String get friendlyUserType {
    switch (_userType) {
      case UserType.surveyor:
        return 'Surveyor';
      case UserType.engineer:
        return 'Engineer';
    }
  }

  set userId(int value) {
    if (_userId != value) {
      _userId = value;
      notifyListeners();
    }
  }

  set userType(UserType value) {
    if (_userType != value) {
      _userType = value;
      notifyListeners();
    }
  }

  /// Flips between user types. In a real app we'd be fixed to whatever the logged in user is.
  void toggleUserType() {
    userType =
        userType == UserType.surveyor ? UserType.engineer : UserType.surveyor;
  }
}
