import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_prototype/src/job_detail/job_controller.dart';
import 'package:survey_prototype/src/job_detail/survey_questions.dart';
import 'package:survey_prototype/src/user/user_controller.dart';

import 'address_confirm.dart';

class JobTabBar extends StatefulWidget {
  const JobTabBar({
    Key? key,
  }) : super(key: key);

  @override
  State<JobTabBar> createState() => _JobTabBarState();
}

class _JobTabBarState extends State<JobTabBar> {
  bool _isSnackBarVisible = false; // Track if SnackBar is currently visible

  bool get _allowSurveyAndPhotoTabs {
    final jobController = context.read<JobController>();
    return jobController.isAddressConfirmed;
  }

  bool canAccessTab(int index) {
    if (index >= 2 && !_allowSurveyAndPhotoTabs) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobController>(builder: (context, jobController, child) {
      return DefaultTabController(
        length: 4,
        child: Builder(builder: (BuildContext tabContext) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  '${jobController.job.jobNumber} - ${jobController.job.postcode}'),
              bottom: TabBar(
                tabs: [
                  const Tab(text: 'Address'),
                  const Tab(text: 'Documents'),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Survey'),
                        if (!canAccessTab(2)) const Icon(Icons.lock, size: 16),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Photos'),
                        if (!canAccessTab(3)) const Icon(Icons.lock, size: 16),
                      ],
                    ),
                  ),
                ],
                onTap: (index) {
                  // Prevent user from navigating past documents tab if address isn't confirmed
                  if (!canAccessTab(index)) {
                    DefaultTabController.of(tabContext).animateTo(0);

                    // Only show SnackBar if another one isn't already visible
                    if (!_isSnackBarVisible) {
                      _isSnackBarVisible = true;
                      ScaffoldMessenger.of(tabContext)
                          .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please confirm the address before proceeding.'),
                              duration: Duration(seconds: 2),
                            ),
                          )
                          .closed
                          .then((reason) {
                        if (!mounted) {
                          // Widget umounted while waiting for the snackbar to finish,
                          // so don't want to try to change state.
                          return;
                        }
                        setState(() {
                          _isSnackBarVisible = false;
                        });
                      });
                    }
                  }
                },
              ),
            ),
            body: TabBarView(
              physics: jobController.isAddressConfirmed
                  ? null
                  : const NeverScrollableScrollPhysics(),
              children: [
                const AddressConfirm(),

                // Documents tab - placeholder
                const Center(
                  child: Text('Documents will be displayed here'),
                ),

                Consumer<UserController>(
                  builder: (context, userController, child) {
                    return SurveyQuestions(
                      userController: userController,
                      jobController: jobController,
                    );
                  },
                ),

                // Photos tab - placeholder
                const Center(
                  child: Text('Photos will be displayed here'),
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
