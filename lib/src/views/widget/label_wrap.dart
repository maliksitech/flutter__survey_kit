import 'package:flutter/material.dart';

class LabeledTextField extends StatelessWidget {
  final String? label;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final InputDecoration? decoration;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  const LabeledTextField({
    Key? key,
    this.label,
    this.textInputAction,
    this.autofocus = false,
    this.decoration,
    this.controller,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: EdgeInsets.only(top: 14.0, bottom: 8.0),
            child: Text(label!,
                style: Theme.of(context).textTheme.labelMedium ??
                    Theme.of(context).textTheme.bodyMedium),
          ),
        TextField(
          textInputAction: textInputAction,
          autofocus: autofocus,
          decoration: decoration,
          controller: controller,
          textAlign: textAlign,
          onChanged: onChanged,
          maxLines: maxLines,
          minLines: minLines,
          keyboardType: keyboardType,
        )
      ],
    );
  }
}
