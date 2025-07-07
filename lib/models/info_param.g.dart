// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoParam _$InfoParamFromJson(Map<String, dynamic> json) => InfoParam(
      key: json['key'] as String,
      name: json['name'] as String,
      label: json['label'] as String,
      required: json['required'] as bool?,
      type: json['type'] as String?,
      options: json['options'] as String?,
    );

Map<String, dynamic> _$InfoParamToJson(InfoParam instance) => <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'label': instance.label,
      'required': instance.required,
      'type': instance.type,
      'options': instance.options,
    };
