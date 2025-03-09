import 'package:flutter/widgets.dart';

import '../models/job_model.dart';

class JobProvider extends InheritedWidget {
  final Job job;

  const JobProvider({
    Key? key,
    required this.job,
    required Widget child,
  }) : super(key: key, child: child);

  static Job of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<JobProvider>();
    if (provider == null) {
      throw FlutterError('No JobProvider found in context');
    }
    return provider.job;
  }

  @override
  bool updateShouldNotify(JobProvider oldWidget) => job != oldWidget.job;
}
