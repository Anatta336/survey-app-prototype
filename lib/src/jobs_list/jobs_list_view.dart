import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_prototype/src/job_detail/job_detail_view.dart';

import 'jobs_list_controller.dart';

/// Displays a list of Jobs.
class JobsListView extends StatelessWidget {
  const JobsListView({
    super.key,
  });

  static const routeName = '/jobs';

  // final List<Job> jobs;

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsListController>(
      builder: (context, jobsListController, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Jobs'),
            actions: const [],
          ),
          body: ListView.builder(
            restorationId: 'jobsListView',
            itemCount: jobsListController.filteredJobs.length,
            itemBuilder: (BuildContext context, int index) {
              final job = jobsListController.filteredJobs[index];

              return ListTile(
                  title: Text('${job.jobNumber} - ${job.postcode}'),
                  onTap: () {
                    Navigator.restorablePushNamed(
                      context,
                      JobDetailView.routeName,
                      arguments: job.id,
                    );
                  });
            },
          ),
        );
      },
    );
  }
}
