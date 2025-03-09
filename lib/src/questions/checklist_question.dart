import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import '../models/answer_model.dart';
import '../models/job_model.dart';
import '../models/question_model.dart';
import '../providers/realm_provider.dart';

class ChecklistQuestion extends StatefulWidget {
  final Question question;
  final Job job;

  const ChecklistQuestion({
    Key? key,
    required this.question,
    required this.job,
  }) : super(key: key);

  @override
  State<ChecklistQuestion> createState() => _ChecklistQuestionState();
}

class _ChecklistQuestionState extends State<ChecklistQuestion> {
  bool _isDone = false;
  bool _cannotComplete = false;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

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
          if (answerModel.answer == 'Not Completed' &&
              answerModel.reasonCannot != null) {
            _cannotComplete = true;
            _reasonController.text = answerModel.reasonCannot!;
          } else {
            _isDone = answerModel.answer == 'Done';
          }
        });
      }
    });
  }

  void _markDone() {
    setState(() {
      _isDone = true;
      _cannotComplete = false;
    });

    reportAnswer();
  }

  void _markCannotComplete() {
    setState(() {
      _isDone = false;
      _cannotComplete = true;
    });

    reportAnswer();
  }

  void reportAnswer() {
    String answerText = _isDone ? 'Done' : 'Not Completed';
    String? reasonText = _cannotComplete ? _reasonController.text : null;

    final realm = RealmProvider.of(context);
    final answerModel = realm
        .query<Answer>(
            'questionId == ${widget.question.id} && jobId == ${widget.job.id}')
        .firstOrNull;

    if (answerModel != null) {
      realm.write(() {
        answerModel.answer = answerText;
        answerModel.reasonCannot = reasonText;
      });
    } else {
      realm.write(() {
        realm.add(
          Answer(
            Uuid.v4().toString(),
            widget.job.id,
            widget.question.id,
            answerText,
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
                onPressed: () => _markDone(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isDone ? Theme.of(context).highlightColor : null,
                  foregroundColor: _isDone ? Colors.white : null,
                ),
                child: const Text('Done'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: () => _markCannotComplete(),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _cannotComplete ? Theme.of(context).highlightColor : null,
                  foregroundColor: _cannotComplete ? Colors.white : null,
                ),
                child: const Text('Cannot Complete'),
              ),
            ),
          ],
        ),
        if (_cannotComplete)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for not completing',
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
