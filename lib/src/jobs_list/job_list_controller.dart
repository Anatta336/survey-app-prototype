import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:survey_prototype/src/user/user_controller.dart';

import '../models/job_model.dart';

/// A class that Widgets can interact with to filter and access jobs.
class JobListController with ChangeNotifier {
  JobListController(
    this._realm,
    this._userController,
  ) {
    _userController.addListener(_onUserChange);
    refreshJobs();
  }

  late List<Job> filteredJobs;
  late String _searchText = '';
  final Realm _realm;
  final UserController _userController;

  @override
  void dispose() {
    _userController.removeListener(_onUserChange);
    super.dispose();
  }

  set searchText(String value) {
    _searchText = value;
    refreshJobs();
  }

  String get searchText => _searchText;

  void _onUserChange() {
    refreshJobs();
  }

  void refreshJobs() {
    var userColumn = _userController.userType == UserType.surveyor
        ? 'surveyorId'
        : 'engineerId';

    // TODO: search all lines of address. Ideally, combining them first.
    filteredJobs = _realm
        .query<Job>(
            '$userColumn == ${_userController.userId} && (jobNumber CONTAINS "$_searchText" OR postcode CONTAINS "$_searchText")')
        .toList();

    notifyListeners();
  }
}
