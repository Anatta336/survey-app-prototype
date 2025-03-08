// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Question extends _Question
    with RealmEntity, RealmObjectBase, RealmObject {
  Question(
    int id,
    int questionTypeIndex,
    int userTypeIndex,
    String questionText, {
    Iterable<String> choices = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'questionTypeIndex', questionTypeIndex);
    RealmObjectBase.set(this, 'userTypeIndex', userTypeIndex);
    RealmObjectBase.set(this, 'questionText', questionText);
    RealmObjectBase.set<RealmList<String>>(
        this, 'choices', RealmList<String>(choices));
  }

  Question._();

  @override
  int get id => RealmObjectBase.get<int>(this, 'id') as int;
  @override
  set id(int value) => RealmObjectBase.set(this, 'id', value);

  @override
  int get questionTypeIndex =>
      RealmObjectBase.get<int>(this, 'questionTypeIndex') as int;
  @override
  set questionTypeIndex(int value) =>
      RealmObjectBase.set(this, 'questionTypeIndex', value);

  @override
  int get userTypeIndex =>
      RealmObjectBase.get<int>(this, 'userTypeIndex') as int;
  @override
  set userTypeIndex(int value) =>
      RealmObjectBase.set(this, 'userTypeIndex', value);

  @override
  String get questionText =>
      RealmObjectBase.get<String>(this, 'questionText') as String;
  @override
  set questionText(String value) =>
      RealmObjectBase.set(this, 'questionText', value);

  @override
  RealmList<String> get choices =>
      RealmObjectBase.get<String>(this, 'choices') as RealmList<String>;
  @override
  set choices(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Question>> get changes =>
      RealmObjectBase.getChanges<Question>(this);

  @override
  Question freeze() => RealmObjectBase.freezeObject<Question>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Question._);
    return const SchemaObject(ObjectType.realmObject, Question, 'Question', [
      SchemaProperty('id', RealmPropertyType.int, primaryKey: true),
      SchemaProperty('questionTypeIndex', RealmPropertyType.int),
      SchemaProperty('userTypeIndex', RealmPropertyType.int),
      SchemaProperty('questionText', RealmPropertyType.string),
      SchemaProperty('choices', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
    ]);
  }
}
