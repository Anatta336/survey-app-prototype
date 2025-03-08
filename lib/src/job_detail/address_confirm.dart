import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_prototype/src/job_detail/job_controller.dart';
import 'package:intl/intl.dart';

import '../models/job_model.dart';

class AddressConfirm extends StatelessWidget {
  const AddressConfirm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<JobController>(
          builder: (context, jobController, child) {
            return _AddressConfirmContent(
                jobController: jobController, job: jobController.job);
          },
        ));
  }
}

class _AddressConfirmContent extends StatelessWidget {
  const _AddressConfirmContent({
    Key? key,
    required this.jobController,
    required this.job,
  }) : super(key: key);

  final JobController jobController;
  final Job job;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Address Confirmation',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        if (job.addressLine1.isNotEmpty) Text(job.addressLine1),
        if (job.addressLine2.isNotEmpty) Text(job.addressLine2),
        if (job.addressLine3.isNotEmpty) Text(job.addressLine3),
        if (job.addressLine4.isNotEmpty) Text(job.addressLine4),
        Text(job.postcode),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            // Null value for onPressed makes the button disabled.
            onPressed: job.addressConfirmedAt != null
                ? null // Button will be disabled when address is confirmed
                : () {
                    jobController.confirmAddress();
                  },
            child: Text(job.addressConfirmedAt != null
                ? 'Confirmed ${DateFormat('HH:mm dd/MMM/yyyy').format(job.addressConfirmedAt!)}'
                : 'Confirm Address'),
          ),
        ),
      ],
    );
  }
}
