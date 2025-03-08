import 'package:realm/realm.dart';
// This extra import solves an intermittent error: https://github.com/realm/realm-dart/issues/1611#issuecomment-2053895133
// ignore: unnecessary_import, depend_on_referenced_packages
import 'package:realm_common/realm_common.dart';

part 'answer_model.g.dart';

@RealmModel()
class _Answer {
  @PrimaryKey()
  late String uuid;
  late int jobId;
  late int questionId;
  late String answer;
  late String? reasonCannot;

  bool get answered => answer.isNotEmpty;
  bool get cannotAnswer => reasonCannot?.isNotEmpty ?? false;
}
