import 'package:json_annotation/json_annotation.dart';

import 'base_model.dart';
import 'param.dart';

part 'service.g.dart';

@JsonSerializable()
class Service extends BaseModel {
  final String name;
  final String description;
  final String serviceType;
  final bool isActive;
  final String basePath;
  final Param params;

  Service({
    required super.id,
    super.createdAt,
    super.updatedAt,
    required this.name,
    required this.description,
    required this.serviceType,
    required this.isActive,
    required this.basePath,
    required this.params,
  });

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
