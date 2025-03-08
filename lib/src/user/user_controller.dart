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
}
