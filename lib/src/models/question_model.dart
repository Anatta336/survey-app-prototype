import 'package:realm/realm.dart';
// This extra import solves an intermittent error: https://github.com/realm/realm-dart/issues/1611#issuecomment-2053895133
// ignore: unnecessary_import, depend_on_referenced_packages
import 'package:realm_common/realm_common.dart';

import '../user/user_controller.dart';

part 'question_model.g.dart';

enum QuestionType {
  yesNo,
  multipleChoice,
  text,
  checklist,
}

@RealmModel()
class _Question {
  @PrimaryKey()
  late int id;

  late int questionTypeIndex;
  QuestionType get questionType {
    return QuestionType.values[questionTypeIndex];
  }

  set questionType(QuestionType value) {
    questionTypeIndex = value.index;
  }

  late int userTypeIndex;
  UserType get userType {
    return UserType.values[userTypeIndex];
  }

  set userType(UserType value) {
    userTypeIndex = value.index;
  }

  late String questionText;
  late List<String> choices; // Empty if not multiple choice.
}
