import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import 'package:survey_prototype/src/models/answer_model.dart';
import 'package:survey_prototype/src/models/question_factory.dart';
import 'package:survey_prototype/src/models/question_model.dart';
import 'package:survey_prototype/src/providers/realm_provider.dart';
import 'package:survey_prototype/src/user/user_controller.dart';

import 'src/app.dart';
import 'src/jobs_list/jobs_list_controller.dart';
import 'src/models/job_model.dart';
import 'src/models/job_factory.dart';

void main() async {
  final userController = UserController();

  // If adding more models, add them to the schema list here.
  final config = Configuration.local(
    [Job.schema, Question.schema, Answer.schema],

    // If there's any changes to the database schema, just drop the existing one.
    shouldDeleteIfMigrationNeeded: true,
  );
  final realm = Realm(config);
  seed(realm);

  final jobsListController = JobsListController(realm);
  await jobsListController.loadJobs();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => userController),
        ChangeNotifierProvider(create: (context) => jobsListController),
      ],
      child: RealmProvider(
        realm: realm,
        child: MyApp(
          realm:
              realm, // TODO: no need to pass it down now, can use RealmProvider.of(context)
        ),
      ),
    ),
  );
}

void seed(Realm realm) {
  realm.write(() {
    realm.add(
      JobFactory.create(
        id: 1,
        surveyorId: 1,
        engineerId: 0,
        jobNumber: 'JOB-001',
        addressLine1: 'Unit 15',
        addressLine2: 'Penfold Drive',
        addressLine3: 'Gateway 11 Business Park',
        addressLine4: 'Wymondham',
        postcode: 'NR18 0WZ',
      ),
      // If there's already a job with ID 1, overwrite it.
      update: true,
    );
    realm.add(
      JobFactory.create(
        id: 2,
        surveyorId: 1,
        engineerId: 0,
        jobNumber: 'JOB-002',
        addressLine1: 'Unit 1.31',
        addressLine2: 'St. John\'s Innovation Centre',
        addressLine3: 'Cowley Road',
        addressLine4: 'Cambridge',
        postcode: 'CB4 0WS',
      ),
      update: true,
    );
  });

  List<Question> questionsToAdd = [];
  var random = Random();
  for (var i = 1; i <= 32; i++) {
    questionsToAdd.add(
      QuestionFactory.create(
        id: i,
        questionType:
            QuestionType.values[random.nextInt(QuestionType.values.length)],
        userType: UserType.values[random.nextInt(UserType.values.length)],
        questionText: 'Example question $i.',
      ),
    );
  }

  realm.write(() {
    realm.addAll<Question>(questionsToAdd, update: true);
  });

  print('Seeded database locally');
}
