import 'package:flutter/material.dart';
import 'package:survey_prototype/src/providers/realm_provider.dart';
import 'package:survey_prototype/src/questions/yes_no.dart';
import 'package:survey_prototype/src/user/user_controller.dart';

import '../models/question_model.dart';

class SurveyQuestions extends StatelessWidget {
  const SurveyQuestions({
    Key? key,
    required this.userController,
  }) : super(key: key);

  final UserController userController;

  @override
  Widget build(BuildContext context) {
    // Access the realm instance through the provider
    final realm = RealmProvider.of(context);

    var questions = realm
        .query<Question>('userTypeIndex == ${userController.userType.index}')
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        restorationId: 'questions',
        itemCount: questions.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text('Survey Questions ${questions.length}',
                  style: Theme.of(context).textTheme.headlineSmall),
            );
          }

          var question = questions[index - 1];

          return Padding(
              padding: const EdgeInsets.only(bottom: 18),
              // TODO: Pick widget based on question type.
              // TODO: Provide current answer from realm. Best to handle in and out within the widget?
              child: YesNoQuestion(
                  questionText: question.questionText,
                  onAnswered: (answer, reasonCannot) {
                    // realm.write(() {
                    //   // TODO: Save answer to realm
                    // });
                    print('Answered: $answer');
                    if (reasonCannot != null) {
                      print('Reason No Answer: $reasonCannot');
                    }
                  }));
        },
      ),
    );
  }
}
