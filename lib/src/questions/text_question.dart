import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import '../models/answer_model.dart';
import '../models/job_model.dart';
import '../models/question_model.dart';
import '../providers/realm_provider.dart';

class TextQuestion extends StatefulWidget {
  final Question question;
  final Job job;

  const TextQuestion({
    Key? key,
    required this.question,
    required this.job,
  }) : super(key: key);

  @override
  State<TextQuestion> createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
  bool _cannotAnswer = false;

  final TextEditingController _answerController = TextEditingController();
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
            _answerController.text = answerModel.answer;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _selectCannotAnswer() {
    setState(() {
      _answerController.clear();
      _cannotAnswer = true;
    });
    reportAnswer();
  }

  void reportAnswer() {
    String answerText = _answerController.text;

    if (answerText.isEmpty) {
      answerText = 'unanswered';
    } else {
      setState(() {
        _cannotAnswer = false;
      });
    }

    String? reasonText = _cannotAnswer ? _reasonController.text : null;

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
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.question.questionText,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Calculate button width - estimate for the "Cannot Answer" button
            // plus some padding
            const buttonWidth = 130.0;
            const spacing = 16.0;

            // Check if we can fit both with TextField being at least 300px
            final hasEnoughSpace =
                constraints.maxWidth >= (300 + buttonWidth + spacing);

            if (hasEnoughSpace) {
              // Use Row layout when there's enough space
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _answerController,
                      decoration: const InputDecoration(
                        labelText: 'Answer',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onChanged: (_) {
                        reportAnswer();
                      },
                    ),
                  ),
                  const SizedBox(width: spacing),
                  ElevatedButton(
                    onPressed: () => _selectCannotAnswer(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _cannotAnswer
                          ? Theme.of(context).highlightColor
                          : null,
                      foregroundColor: _cannotAnswer ? Colors.white : null,
                    ),
                    child: const Text('Cannot Answer'),
                  ),
                ],
              );
            } else {
              // Use Column layout when space is limited
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      labelText: 'Answer',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    onChanged: (_) {
                      reportAnswer();
                    },
                  ),
                  const SizedBox(height: spacing),
                  ElevatedButton(
                    onPressed: () => _selectCannotAnswer(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _cannotAnswer
                          ? Theme.of(context).highlightColor
                          : null,
                      foregroundColor: _cannotAnswer ? Colors.white : null,
                    ),
                    child: const Text('Cannot Answer'),
                  ),
                ],
              );
            }
          },
        ),
        if (_cannotAnswer)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
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
          ),
      ],
    );
  }
}
