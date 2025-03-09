import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_prototype/src/job_detail/job_detail_view.dart';
import 'package:survey_prototype/src/user/user_controller.dart';

import 'jobs_list_controller.dart';

/// Displays a list of Jobs.
class JobsListView extends StatelessWidget {
  static const routeName = '/jobs';

  const JobsListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<JobsListController, UserController>(
      builder: (context, jobsListController, userController, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${userController.friendlyUserType} Jobs'),
            actions: [
              IconButton(
                icon: const Icon(Icons.group),
                onPressed: userController.toggleUserType,
              ),
            ],
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
