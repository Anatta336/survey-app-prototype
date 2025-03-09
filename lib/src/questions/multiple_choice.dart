import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:survey_prototype/src/models/job_model.dart';
import '../models/answer_model.dart';
import '../models/question_model.dart';
import '../providers/realm_provider.dart';

/// A widget that presents a multiple choice question to the user.
class MultipleChoiceQuestion extends StatefulWidget {
  final Question question;
  final List<String> choices;
  final Job job;

  /// Creates a multiple choice question widget.
  const MultipleChoiceQuestion({
    Key? key,
    required this.question,
    required this.choices,
    required this.job,
  }) : super(key: key);

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  String? _selectedAnswer;
  bool _cannotAnswer = false;

  // Controller for the reason text field
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Wrap in a post-frame callback to ensure the full widget tree is available.
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
            _selectedAnswer = answerModel.answer;
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

  void _selectAnswer(String? answer) {
    setState(() {
      _selectedAnswer = answer;
      _cannotAnswer = false;
    });

    _onSetAnswer();
  }

  void _selectCannotAnswer() {
    setState(() {
      _selectedAnswer = null;
      _cannotAnswer = true;
    });

    _onSetAnswer();
  }

  void _onSetAnswer() {
    String answerText = (_cannotAnswer || (_selectedAnswer == null))
        ? 'unanswered'
        : _selectedAnswer!;
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.question.questionText,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8.0),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // Create a responsive button layout that fills available width
            return SizedBox(
              width: constraints.maxWidth,
              child: Wrap(
                spacing: 16.0, // Horizontal spacing
                runSpacing: 8.0, // Vertical spacing between rows
                alignment: WrapAlignment.start,
                children: [
                  ...widget.choices.map((choice) {
                    return ElevatedButton(
                      onPressed: () => _selectAnswer(choice),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedAnswer == choice
                            ? Theme.of(context).highlightColor
                            : null,
                        foregroundColor:
                            _selectedAnswer == choice ? Colors.white : null,
                        minimumSize: const Size.fromHeight(40),
                      ),
                      child: Text(choice, textAlign: TextAlign.center),
                    );
                  }),
                  // Cannot Answer button with same width calculation
                  ElevatedButton(
                    onPressed: () => _selectCannotAnswer(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _cannotAnswer
                          ? Theme.of(context).highlightColor
                          : null,
                      foregroundColor: _cannotAnswer ? Colors.white : null,
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text('Cannot Answer',
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            );
          },
        ),
        if (_cannotAnswer)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: TextField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for no answer',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              onChanged: (_) {
                _onSetAnswer();
              },
            ),
          ),
      ],
    );
  }
}
