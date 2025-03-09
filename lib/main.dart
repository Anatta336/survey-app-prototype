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
        child: const MyApp(),
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

  realm.write(() {
    realm.deleteAll<Question>();
  });

  List<Question> questionsToAdd = [];
  var random = Random();
  for (var i = 1; i <= 128; i++) {
    final questionType =
        QuestionType.values[random.nextInt(QuestionType.values.length)];
    final userType = UserType.values[random.nextInt(UserType.values.length)];
    var choices = <String>[];

    if (questionType == QuestionType.multipleChoice) {
      final numChoices = random.nextInt(4) + 2;
      for (var j = 1; j <= numChoices; j++) {
        if (random.nextInt(3) == 0) {
          // Some have longer text.
          choices.add('Choice $j lorem ipsum dolor sit amet consectetur');
        } else {
          choices.add('Choice $j');
        }
      }
    }

    var friendlyTypeName = questionType.name;

    switch (questionType) {
      case QuestionType.yesNo:
        friendlyTypeName = 'yes/no question';
        break;
      case QuestionType.multipleChoice:
        friendlyTypeName = 'multiple choice question';
        break;
      case QuestionType.text:
        friendlyTypeName = 'text question';
        break;
      case QuestionType.checklist:
        friendlyTypeName = 'checklist item';
        break;
    }

    var questionText = 'Example $friendlyTypeName.';
    if (random.nextInt(3) == 0) {
      // Some have longer text.

      questionText =
          'Example ${questionType.name} question. Lorem ipsum dolor sit amet consectetur adipiscing elit.';
    }

    questionsToAdd.add(
      QuestionFactory.create(
        id: i,
        questionType: questionType,
        userType: userType,
        questionText: questionText,
        choices: choices,
      ),
    );
  }

  realm.write(() {
    realm.addAll<Question>(questionsToAdd, update: true);
  });

  print('Seeded database locally');
}
