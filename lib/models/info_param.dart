import 'package:json_annotation/json_annotation.dart';

part 'info_param.g.dart';

@JsonSerializable()
class InfoParam {
  final String key, name, label;
  final bool? required;
  final String? type, options;

  InfoParam({
    required this.key,
    required this.name,
    required this.label,
    this.required,
    this.type,
    this.options,
  });

  factory InfoParam.fromJson(Map<String, dynamic> json) => _$InfoParamFromJson(json);

  Map<String, dynamic> toJson() => _$InfoParamToJson(this);
}