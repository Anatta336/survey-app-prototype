import 'package:flutter/material.dart';
import 'package:survey_prototype/src/providers/realm_provider.dart';
import 'package:survey_prototype/src/questions/checklist_question.dart';
import 'package:survey_prototype/src/questions/yes_no.dart';
import 'package:survey_prototype/src/questions/multiple_choice.dart';
import 'package:survey_prototype/src/questions/text_question.dart';
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
          return Column(
            children: [
              _buildQuestionWidget(question),
              if (index < questions.length)
                const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Divider(height: 1)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuestionWidget(Question question) {
    switch (question.questionType) {
      case QuestionType.yesNo:
        return YesNoQuestion(
          questionText: question.questionText,
          onAnswered: _handleAnswer,
        );
      case QuestionType.multipleChoice:
        return MultipleChoiceQuestion(
          questionText: question.questionText,
          choices: question.choices,
          onAnswered: _handleAnswer,
        );
      case QuestionType.text:
        return TextQuestion(
          questionText: question.questionText,
          onAnswered: _handleAnswer,
        );
      case QuestionType.checklist:
        return ChecklistQuestion(
          questionText: question.questionText,
          onAnswered: _handleAnswer,
        );
      default:
        return Text(
            'Unknown question type for: [${question.id}] ${question.questionText}');
    }
  }

  void _handleAnswer(String answer, String? reasonCannot) {
    // realm.write(() {
    //   // TODO: Save answer to realm
    // });
    print('Answered: $answer');
    if (reasonCannot != null) {
      print('Reason No Answer: $reasonCannot');
    }
  }
}
