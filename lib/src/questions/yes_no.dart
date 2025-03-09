import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import '../models/answer_model.dart';
import '../models/job_model.dart';
import '../models/question_model.dart';
import '../providers/realm_provider.dart';

enum YesNoAnswer {
  unanswered,
  yes,
  no,
}

/// A widget that presents a yes/no question to the user.
class YesNoQuestion extends StatefulWidget {
  /// The question to be displayed.
  final Question question;

  /// The job associated with the question.
  final Job job;

  /// Creates a yes/no question widget.
  const YesNoQuestion({
    Key? key,
    required this.question,
    required this.job,
  }) : super(key: key);

  @override
  State<YesNoQuestion> createState() => _YesNoQuestionState();
}

class _YesNoQuestionState extends State<YesNoQuestion> {
  YesNoAnswer _selectedAnswer = YesNoAnswer.unanswered;
  bool _cannotAnswer = false;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final realm = RealmProvider.of(context);
      final answerModel = realm
          .query<Answer>(
              'questionId == ${widget.question.id} && jobId == ${widget.job.id}')
          .firstOrNull;

      if (answerModel != null) {
        setState(() {
          if (answerModel.answer == 'unanswered' &&
              answerModel.reasonCannot != null) {
            _cannotAnswer = true;
            _reasonController.text = answerModel.reasonCannot!;
          } else {
            _selectedAnswer = YesNoAnswer.values.firstWhere(
                (e) => e.toString().split('.').last == answerModel.answer,
                orElse: () => YesNoAnswer.unanswered);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _selectAnswer(YesNoAnswer answer) {
    setState(() {
      _selectedAnswer = answer;
      _cannotAnswer = false;
    });

    reportAnswer();
  }

  void _selectCannotAnswer() {
    setState(() {
      _selectedAnswer = YesNoAnswer.unanswered;
      _cannotAnswer = true;
    });

    reportAnswer();
  }

  void reportAnswer() {
    String answerText = _selectedAnswer.toString().split('.').last;
    String? reasonText = _cannotAnswer ? _reasonController.text : null;

    final realm = RealmProvider.of(context);
    final answerModel = realm
        .query<Answer>(
            'questionId == ${widget.question.id} && jobId == ${widget.job.id}')
        .firstOrNull;

    if (answerModel != null) {
      realm.write(() {
        answerModel.answer = _cannotAnswer ? 'unanswered' : answerText;
        answerModel.reasonCannot = reasonText;
      });
    } else {
      realm.write(() {
        realm.add(
          Answer(
            Uuid.v4().toString(),
            widget.job.id,
            widget.question.id,
            _cannotAnswer ? 'unanswered' : answerText,
            reasonCannot: reasonText,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.questionText,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: () => _selectAnswer(YesNoAnswer.yes),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedAnswer == YesNoAnswer.yes
                      ? Theme.of(context).highlightColor
                      : null,
                  foregroundColor:
                      _selectedAnswer == YesNoAnswer.yes ? Colors.white : null,
                ),
                child: const Text('Yes'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: () => _selectAnswer(YesNoAnswer.no),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedAnswer == YesNoAnswer.no
                      ? Theme.of(context).highlightColor
                      : null,
                  foregroundColor:
                      _selectedAnswer == YesNoAnswer.no ? Colors.white : null,
                ),
                child: const Text('No'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: () => _selectCannotAnswer(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _cannotAnswer ? Theme.of(context).highlightColor : null,
                  foregroundColor: _cannotAnswer ? Colors.white : null,
                ),
                child: const Text('Cannot Answer'),
              ),
            ),
          ],
        ),
        if (_cannotAnswer)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for no answer',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (_) {
                reportAnswer();
              },
            ),
          ),
      ],
    );
  }
}
