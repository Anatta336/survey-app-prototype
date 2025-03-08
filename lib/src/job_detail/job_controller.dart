import 'package:flutter/foundation.dart';
import 'package:survey_prototype/src/models/job_model.dart';

/// Controller for an individual job.
class JobController extends ChangeNotifier {
  final Job _job;

  JobController({
    required Job job,
  }) : _job = job;

  Job get job => _job;

  bool get isAddressConfirmed => _job.addressConfirmedAt != null;

  void confirmAddress() {
    _job.realm.write(() {
      _job.addressConfirmedAt = DateTime.now();
    });

    notifyListeners();
  }
}
