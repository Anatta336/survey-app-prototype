import 'package:flutter/material.dart';
import 'package:realm/realm.dart';

import '../models/job_model.dart';

/// A class that many Widgets can interact with filter and access jobs.
///
/// Controllers glue Data Services to Flutter Widgets.
class JobsListController with ChangeNotifier {
  JobsListController(this.realm);

  late List<Job> _jobs;
  late final Realm realm;

  List<Job> get filteredJobs => _jobs;

  Future<void> loadJobs() async {
    _jobs = realm.all<Job>().toList();

    notifyListeners();
  }

  // TODO: Filter jobs based on search text, and notify listeners.
}
