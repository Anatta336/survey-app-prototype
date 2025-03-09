import 'package:flutter/material.dart';

/// A widget that presents a freeform text question to the user.
class TextQuestion extends StatefulWidget {
  /// The text of the question to be displayed.
  final String questionText;

  /// Optional callback for when an answer is selected.
  final Function(String answer, String? reasonCannot)? onAnswered;

  /// Creates a freeform text question widget.
  const TextQuestion({
    Key? key,
    required this.questionText,
    this.onAnswered,
  }) : super(key: key);

  @override
  State<TextQuestion> createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> {
  bool _cannotAnswer = false;

  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _selectCannotAnswer() {
    setState(() {
      _cannotAnswer = true;
    });

    reportAnswer();
  }

  void reportAnswer() {
    if (widget.onAnswered == null) {
      return;
    }
    String answer = _cannotAnswer ? 'unanswered' : _answerController.text;
    String? reason = _cannotAnswer ? _reasonController.text : null;
    widget.onAnswered!(answer, reason);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            widget.questionText,
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
