import 'package:flutter/material.dart';

enum YesNoAnswer {
  unanswered,
  yes,
  no,
  cannotAnswer,
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
  // The user's selected response
  YesNoAnswer _selectedAnswer = YesNoAnswer.unanswered;

  // Controller for the reason text field
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _selectAnswer(YesNoAnswer answer) {
    setState(() {
      _selectedAnswer = answer;
    });

    reportAnswer();
  }

  void reportAnswer() {
    if (widget.onAnswered != null) {
      String answerText = _selectedAnswer.toString().split('.').last;
      String? reason = _selectedAnswer == YesNoAnswer.cannotAnswer
          ? _reasonController.text
          : null;
      widget.onAnswered!(answerText, reason);
    }
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
            ElevatedButton(
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
            const SizedBox(width: 16.0),
            ElevatedButton(
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
            const SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: () => _selectAnswer(YesNoAnswer.cannotAnswer),
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedAnswer == YesNoAnswer.cannotAnswer
                    ? Theme.of(context).highlightColor
                    : null,
                foregroundColor: _selectedAnswer == YesNoAnswer.cannotAnswer
                    ? Colors.white
                    : null,
              ),
              child: const Text('Cannot Answer'),
            ),
          ],
        ),
        if (_selectedAnswer == YesNoAnswer.cannotAnswer)
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
