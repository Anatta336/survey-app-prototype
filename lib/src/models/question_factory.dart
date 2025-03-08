import '../user/user_controller.dart';
import 'question_model.dart';

class QuestionFactory {
  static Question create({
    required int id,
    required QuestionType questionType,
    required UserType userType,
    required String questionText,
    List<String> choices = const [],
  }) {
    if (questionType != QuestionType.multipleChoice) {
      // Ignore choices if not multiple choice.
      choices = [];
    }

    return Question(
      id,
      questionType.index,
      userType.index,
      questionText,
      choices: choices,
    );
  }
}
