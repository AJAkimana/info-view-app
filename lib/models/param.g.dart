// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Param _$ParamFromJson(Map<String, dynamic> json) => Param(
      method: json['method'] as String?,
      body: (json['body'] as List<dynamic>?)
          ?.map((e) => InfoParam.fromJson(e as Map<String, dynamic>))
          .toList(),
      params: (json['params'] as List<dynamic>?)
          ?.map((e) => InfoParam.fromJson(e as Map<String, dynamic>))
          .toList(),
      query: (json['query'] as List<dynamic>?)
          ?.map((e) => InfoParam.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ParamToJson(Param instance) => <String, dynamic>{
      'method': instance.method,
      'body': instance.body,
      'params': instance.params,
      'query': instance.query,
    };
