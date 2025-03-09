import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_prototype/src/job_detail/job_detail_view.dart';
import 'package:survey_prototype/src/user/user_controller.dart';

import 'job_list_controller.dart';

/// Displays a list of Jobs. Which jobs to show are decided by JobsListController.
class JobListView extends StatelessWidget {
  static const routeName = '/jobs';

  const JobListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<JobListController, UserController>(
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
          body: Column(
            children: [
              _SearchField(jobsListController: jobsListController),
              Expanded(
                child: ListView.builder(
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
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchField extends StatefulWidget {
  final JobListController jobsListController;

  const _SearchField({required this.jobsListController});

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: widget.jobsListController.searchText);
  }

  @override
  void didUpdateWidget(covariant _SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update the controller if the controller's text doesn't match searchText
    // This avoids cursor jumps during typing
    if (_controller.text != widget.jobsListController.searchText) {
      _controller.text = widget.jobsListController.searchText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search jobs...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.jobsListController.searchText.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.jobsListController.searchText = '';
                    _controller.clear();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          filled: true,
          fillColor:
              Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        controller: _controller,
        onChanged: (value) {
          widget.jobsListController.searchText = value;
        },
      ),
    );
  }
}
