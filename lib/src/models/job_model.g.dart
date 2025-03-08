// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Job extends _Job with RealmEntity, RealmObjectBase, RealmObject {
  Job(
    int id,
    int surveyorId,
    int engineerId,
    String jobNumber,
    String addressLine1,
    String addressLine2,
    String addressLine3,
    String addressLine4,
    String postcode,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'surveyorId', surveyorId);
    RealmObjectBase.set(this, 'engineerId', engineerId);
    RealmObjectBase.set(this, 'jobNumber', jobNumber);
    RealmObjectBase.set(this, 'addressLine1', addressLine1);
    RealmObjectBase.set(this, 'addressLine2', addressLine2);
    RealmObjectBase.set(this, 'addressLine3', addressLine3);
    RealmObjectBase.set(this, 'addressLine4', addressLine4);
    RealmObjectBase.set(this, 'postcode', postcode);
  }

  Job._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get surveyorId => RealmObjectBase.get<int>(this, 'surveyorId') as int;
  @override
  set surveyorId(int value) => RealmObjectBase.set(this, 'surveyorId', value);

  @override
  int get engineerId => RealmObjectBase.get<int>(this, 'engineerId') as int;
  @override
  set engineerId(int value) => RealmObjectBase.set(this, 'engineerId', value);

  @override
  String get jobNumber =>
      RealmObjectBase.get<String>(this, 'jobNumber') as String;
  @override
  set jobNumber(String value) => RealmObjectBase.set(this, 'jobNumber', value);

  @override
  String get addressLine1 =>
      RealmObjectBase.get<String>(this, 'addressLine1') as String;
  @override
  set addressLine1(String value) =>
      RealmObjectBase.set(this, 'addressLine1', value);

  @override
  String get addressLine2 =>
      RealmObjectBase.get<String>(this, 'addressLine2') as String;
  @override
  set addressLine2(String value) =>
      RealmObjectBase.set(this, 'addressLine2', value);

  @override
  String get addressLine3 =>
      RealmObjectBase.get<String>(this, 'addressLine3') as String;
  @override
  set addressLine3(String value) =>
      RealmObjectBase.set(this, 'addressLine3', value);

  @override
  String get addressLine4 =>
      RealmObjectBase.get<String>(this, 'addressLine4') as String;
  @override
  set addressLine4(String value) =>
      RealmObjectBase.set(this, 'addressLine4', value);

  @override
  String get postcode =>
      RealmObjectBase.get<String>(this, 'postcode') as String;
  @override
  set postcode(String value) => RealmObjectBase.set(this, 'postcode', value);

  @override
  Stream<RealmObjectChanges<Job>> get changes =>
      RealmObjectBase.getChanges<Job>(this);

  @override
  Job freeze() => RealmObjectBase.freezeObject<Job>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Job._);
    return const SchemaObject(ObjectType.realmObject, Job, 'Job', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('surveyorId', RealmPropertyType.int),
      SchemaProperty('engineerId', RealmPropertyType.int),
      SchemaProperty('jobNumber', RealmPropertyType.string),
      SchemaProperty('addressLine1', RealmPropertyType.string),
      SchemaProperty('addressLine2', RealmPropertyType.string),
      SchemaProperty('addressLine3', RealmPropertyType.string),
      SchemaProperty('addressLine4', RealmPropertyType.string),
      SchemaProperty('postcode', RealmPropertyType.string),
    ]);
  }
}
