// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_answer_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextAnswerFormat _$TextAnswerFormatFromJson(Map<String, dynamic> json) =>
    TextAnswerFormat(
      maxLines: json['maxLines'] as int? ?? 1,
      minLines: json['minLines'] as int?,
      hint: json['hint'] as String? ?? '',
      defaultValue: json['defaultValue'] as String?,
      validationRegEx: json['validationRegEx'] as String? ?? r'^(?!s*$).+',
    );

Map<String, dynamic> _$TextAnswerFormatToJson(TextAnswerFormat instance) =>
    <String, dynamic>{
      'maxLines': instance.maxLines,
      'minLines': instance.minLines,
      'defaultValue': instance.defaultValue,
      'hint': instance.hint,
      'validationRegEx': instance.validationRegEx,
    };
