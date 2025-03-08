import 'package:flutter/material.dart';

import '../models/job_model.dart';

/// Displays detailed information about a SampleItem.
class JobDetailView extends StatelessWidget {
  const JobDetailView({
    super.key,
    required this.job,
  });

  final Job job;

  static const routeName = '/job';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${job.jobNumber} - ${job.postcode}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (job.addressLine1.isNotEmpty) Text(job.addressLine1),
            if (job.addressLine2.isNotEmpty) Text(job.addressLine2),
            if (job.addressLine3.isNotEmpty) Text(job.addressLine3),
            if (job.addressLine4.isNotEmpty) Text(job.addressLine4),
            Text(job.postcode),
          ],
        ),
      ),
    );
  }
}
