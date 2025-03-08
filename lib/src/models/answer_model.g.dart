// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Answer extends _Answer with RealmEntity, RealmObjectBase, RealmObject {
  Answer(
    String uuid,
    int jobId,
    int questionId,
    String answer, {
    String? reasonCannot,
  }) {
    RealmObjectBase.set(this, 'uuid', uuid);
    RealmObjectBase.set(this, 'jobId', jobId);
    RealmObjectBase.set(this, 'questionId', questionId);
    RealmObjectBase.set(this, 'answer', answer);
    RealmObjectBase.set(this, 'reasonCannot', reasonCannot);
  }

  Answer._();

  @override
  String get uuid => RealmObjectBase.get<String>(this, 'uuid') as String;
  @override
  set uuid(String value) => RealmObjectBase.set(this, 'uuid', value);

  @override
  int get jobId => RealmObjectBase.get<int>(this, 'jobId') as int;
  @override
  set jobId(int value) => RealmObjectBase.set(this, 'jobId', value);

  @override
  int get questionId => RealmObjectBase.get<int>(this, 'questionId') as int;
  @override
  set questionId(int value) => RealmObjectBase.set(this, 'questionId', value);

  @override
  String get answer => RealmObjectBase.get<String>(this, 'answer') as String;
  @override
  set answer(String value) => RealmObjectBase.set(this, 'answer', value);

  @override
  String? get reasonCannot =>
      RealmObjectBase.get<String>(this, 'reasonCannot') as String?;
  @override
  set reasonCannot(String? value) =>
      RealmObjectBase.set(this, 'reasonCannot', value);

  @override
  Stream<RealmObjectChanges<Answer>> get changes =>
      RealmObjectBase.getChanges<Answer>(this);

  @override
  Answer freeze() => RealmObjectBase.freezeObject<Answer>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Answer._);
    return const SchemaObject(ObjectType.realmObject, Answer, 'Answer', [
      SchemaProperty('uuid', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('jobId', RealmPropertyType.int),
      SchemaProperty('questionId', RealmPropertyType.int),
      SchemaProperty('answer', RealmPropertyType.string),
      SchemaProperty('reasonCannot', RealmPropertyType.string, optional: true),
    ]);
  }
}
