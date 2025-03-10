import 'package:realm/realm.dart';
// This extra import solves an intermittent error: https://github.com/realm/realm-dart/issues/1611#issuecomment-2053895133
// ignore: unnecessary_import, depend_on_referenced_packages
import 'package:realm_common/realm_common.dart';

// This part file is generated by Realm when we run `dart run realm generate`.
// You need to run that command every time you make changes to the model.
// The class we actually use to interact with Jobs is generated by Realm, and
// extends the class defined here.
part 'job_model.g.dart';

@RealmModel()
class _Job {
  @PrimaryKey()
  late int id;
  late int surveyorId;
  late int engineerId;
  late String jobNumber;

  late String addressLine1;
  late String addressLine2;
  late String addressLine3;
  late String addressLine4;

  late String postcode;

  late DateTime? addressConfirmedAt;
  late DateTime? documentsReadAt; // Do this per document instead?
  late DateTime? surveyorCompletedAt;
  late DateTime? engineerCompletedAt;
}
