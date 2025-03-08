import 'job_model.dart';

class JobFactory {
  static Job create({
    required int id,
    required int surveyorId,
    required int engineerId,
    required String jobNumber,
    required String addressLine1,
    String addressLine2 = '',
    String addressLine3 = '',
    String addressLine4 = '',
    required String postcode,
  }) {
    return Job(
      id,
      surveyorId,
      engineerId,
      jobNumber,
      addressLine1,
      addressLine2,
      addressLine3,
      addressLine4,
      postcode,
    );
  }
}
