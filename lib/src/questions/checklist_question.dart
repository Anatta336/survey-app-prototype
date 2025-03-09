import 'package:flutter/material.dart';

/// A widget that presents a yes/no question to the user.
class ChecklistQuestion extends StatefulWidget {
  /// The text of the question to be displayed.
  final String questionText;

  /// Optional callback for when an answer is selected.
  final Function(String answer, String? reasonCannot)? onAnswered;

  /// Creates a yes/no question widget.
  const ChecklistQuestion({
    Key? key,
    required this.questionText,
    this.onAnswered,
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
    if (widget.onAnswered == null) {
      return;
    }
    String answerText = _isDone ? 'Done' : 'Not Completed';
    String? reason = _cannotComplete ? _reasonController.text : null;
    widget.onAnswered!(answerText, reason);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.questionText,
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
