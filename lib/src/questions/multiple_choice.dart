import 'package:flutter/material.dart';

/// A widget that presents a yes/no question to the user.
class MultipleChoiceQuestion extends StatefulWidget {
  /// The text of the question to be displayed.
  final String questionText;

  final List<String> choices;

  /// Optional callback for when an answer is selected.
  final Function(String answer, String? reasonCannot)? onAnswered;

  /// Creates a multiple choice question widget.
  const MultipleChoiceQuestion({
    Key? key,
    required this.questionText,
    required this.choices,
    this.onAnswered,
  }) : super(key: key);

  @override
  State<MultipleChoiceQuestion> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  // The user's selected response
  String? _selectedAnswer;

  bool _cannotAnswer = false;

  // Controller for the reason text field
  final TextEditingController _reasonController = TextEditingController();

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

    reportAnswer();
  }

  void _selectCannotAnswer() {
    setState(() {
      _selectedAnswer = null;
      _cannotAnswer = true;
    });

    reportAnswer();
  }

  void reportAnswer() {
    if (widget.onAnswered == null) {
      return;
    }
    String answerText =
        (_selectedAnswer != null) ? _selectedAnswer! : 'unanswered';
    String? reason = _cannotAnswer ? _reasonController.text : null;
    widget.onAnswered!(answerText, reason);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.questionText,
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
                reportAnswer();
              },
            ),
          ),
      ],
    );
  }
}
