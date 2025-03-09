import 'package:flutter/material.dart';

enum YesNoAnswer {
  unanswered,
  yes,
  no,
}

/// A widget that presents a yes/no question to the user.
class YesNoQuestion extends StatefulWidget {
  /// The text of the question to be displayed.
  final String questionText;

  /// Optional callback for when an answer is selected.
  final Function(String answer, String? reasonCannot)? onAnswered;

  /// Creates a yes/no question widget.
  const YesNoQuestion({
    Key? key,
    required this.questionText,
    this.onAnswered,
  }) : super(key: key);

  @override
  State<YesNoQuestion> createState() => _YesNoQuestionState();
}

class _YesNoQuestionState extends State<YesNoQuestion> {
  YesNoAnswer _selectedAnswer = YesNoAnswer.unanswered;
  bool _cannotAnswer = false;
  final TextEditingController _reasonController = TextEditingController();

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
    if (widget.onAnswered == null) {
      return;
    }
    String answerText = _selectedAnswer.toString().split('.').last;
    String? reason = _cannotAnswer ? _reasonController.text : null;
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
