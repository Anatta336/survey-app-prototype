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

    var userJobs =
        _realm.query<Job>('$userColumn == ${_userController.userId}').toList();

    if (_searchText.isEmpty) {
      // No need for further filtering.
      filteredJobs = userJobs;
      notifyListeners();
      return;
    }

    filteredJobs = userJobs.where((job) {
      if (job.jobNumber.toLowerCase().contains(_searchText.toLowerCase())) {
        return true;
      }

      final combined = [
        job.addressLine1,
        job.addressLine2,
        job.addressLine3,
        job.addressLine4,
        job.postcode,
      ].join(' ');

      return combined.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    notifyListeners();
  }
}
