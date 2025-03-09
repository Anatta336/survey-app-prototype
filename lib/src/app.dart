import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'job_detail/job_detail_view.dart';
import 'jobs_list/jobs_list_view.dart';
import 'models/job_model.dart';
import 'providers/realm_provider.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return MaterialApp(
      // Providing a restorationScopeId allows the Navigator built by the
      // MaterialApp to restore the navigation stack when a user leaves and
      // returns to the app after it has been killed while running in the
      // background.
      restorationScopeId: 'app',

      // Provide the generated AppLocalizations to the MaterialApp. This
      // allows descendant Widgets to display the correct translations
      // depending on the user's locale.
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],

      title: 'Survey Prototype',

      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),

      // Define a function to handle named routes in order to support
      // Flutter web url navigation and deep linking.
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            // Inidividual jobs have their ID in route's arguments.
            if (routeSettings.name == JobDetailView.routeName) {
              final realm = RealmProvider.of(context);
              final job = realm.find<Job>(routeSettings.arguments as int);

              if (job == null) {
                return const JobsListView();
              }
              return JobDetailView(job: job);
            }

            // These routes don't need any arguments.
            switch (routeSettings.name) {
              case JobsListView.routeName:
              default:
                return const JobsListView();
            }
          },
        );
      },
    );
  }
}
