import 'package:info_viewer/models/info_param.dart';
import 'package:json_annotation/json_annotation.dart';

part 'param.g.dart';

@JsonSerializable()
class Param {
  final String? method;
  final List<InfoParam>? body, params, query;

  Param({
    this.method,
    this.body,
    this.params,
    this.query,
  });

  factory Param.fromJson(Map<String, dynamic> json) => _$ParamFromJson(json);

  Map<String, dynamic> toJson() => _$ParamToJson(this);
}