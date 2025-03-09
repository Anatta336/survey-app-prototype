import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_prototype/src/job_detail/job_controller.dart';
import 'package:survey_prototype/src/job_detail/job_tab_bar.dart';

import '../models/job_model.dart';

/// Base of the job display screen.
class JobDetailView extends StatelessWidget {
  static const routeName = '/job';

  const JobDetailView({
    super.key,
    required this.job,
  });

  final Job job;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<JobController>(
      create: (context) => JobController(job: job),
      child: const JobTabBar(),
    );
  }
}
