import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../survey_kit.dart';

class MultipleChoiceAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final MultipleChoiceQuestionResult? result;

  const MultipleChoiceAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _MultipleChoiceAnswerView createState() => _MultipleChoiceAnswerView();
}

class _MultipleChoiceAnswerView extends State<MultipleChoiceAnswerView> {
  late final DateTime _startDateTime;
  late final MultipleChoiceAnswerFormat _multipleChoiceAnswer;

  List<TextChoice> _selectedChoices = [];

  @override
  void initState() {
    super.initState();
    _multipleChoiceAnswer =
        widget.questionStep.answerFormat as MultipleChoiceAnswerFormat;
    _selectedChoices =
        widget.result?.result ?? _multipleChoiceAnswer.defaultSelection;
    _startDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () => MultipleChoiceQuestionResult(
        id: widget.questionStep.stepIdentifier,
        startDate: _startDateTime,
        endDate: DateTime.now(),
        valueIdentifier:
            _selectedChoices.map((choices) => choices.value).join(','),
        result: _selectedChoices,
      ),
      isValid: widget.questionStep.isOptional || _selectedChoices.isNotEmpty,
      title: widget.questionStep.title.isNotEmpty
          ? Text(
              widget.questionStep.title,
              style: Theme.of(context).textTheme.displayMedium,
              // textAlign: TextAlign.center,
            )
          : widget.questionStep.content,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text(
                widget.questionStep.text,
                style: Theme.of(context).textTheme.bodyMedium,
                // textAlign: TextAlign.center,
              ),
            ),
            ListWithSpacer(
              children: [
                // Divider(
                //   color: Colors.grey,
                // ),
                ..._multipleChoiceAnswer.textChoices
                    .map(
                      (TextChoice tc) => SelectionListTile(
                        text: tc.text,
                        onTap: () {
                          setState(
                            () {
                              if (_selectedChoices.contains(tc)) {
                                _selectedChoices.remove(tc);
                              } else {
                                if (_multipleChoiceAnswer.maxAnswers >
                                    _selectedChoices.length) {
                                  _selectedChoices = [..._selectedChoices, tc];
                                }
                              }
                            },
                          );
                        },
                        isSelected: _selectedChoices.contains(tc),
                      ),
                    )
                    .toList(),
                if (_multipleChoiceAnswer.otherField) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: ListTile(
                      title: TextField(
                        onChanged: (v) {
                          int? currentIndex;
                          final otherTextChoice = _selectedChoices
                              .firstWhereIndexedOrNull((index, element) {
                            final isOtherField = element.text == 'Other';

                            if (isOtherField) {
                              currentIndex = index;
                            }

                            return isOtherField;
                          });

                          setState(() {
                            if (v.isEmpty && otherTextChoice != null) {
                              _selectedChoices.remove(otherTextChoice);
                            } else if (v.isNotEmpty) {
                              final updatedTextChoice =
                                  TextChoice(text: 'Other', value: v);
                              if (otherTextChoice == null) {
                                _selectedChoices.add(updatedTextChoice);
                              } else if (currentIndex != null) {
                                _selectedChoices[currentIndex!] =
                                    updatedTextChoice;
                              }
                            }
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Other',
                          labelStyle: Theme.of(context).textTheme.headlineSmall,
                          hintText: 'Write other information here',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),
                  ),
                  // Divider(
                  //   color: Colors.grey,
                  // ),
                ],
              ],
            ),
            bottomSpacer,
          ],
        ),
      ),
    );
  }
}
