class Param {
  final String method;
  final dynamic body;
  final List<Map<String, dynamic>>? params;
  final String? query;

  Param({
    required this.method,
    this.body,
    this.params,
    this.query,
  });

  factory Param.fromJson(Map<String, dynamic> json) {
    return Param(
      method: json['method'] ?? '',
      body: json['body'],
      params: json['params'] != null
          ? List<Map<String, dynamic>>.from((json['params'] as List).map((e) => Map<String, dynamic>.from(e)))
          : null,
      query: json['query'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'body': body,
      'params': params,
      'query': query,
    };
  }
}

class IBase {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IBase({
    required this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory IBase.fromJson(Map<String, dynamic> json) {
    return IBase(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Service extends IBase {
  final String name;
  final String description;
  final String serviceType;
  final bool isActive;
  final String basePath;
  final Param params;

  Service({
    required String id,
    DateTime? createdAt,
    DateTime? updatedAt,
    required this.name,
    required this.description,
    required this.serviceType,
    required this.isActive,
    required this.basePath,
    required this.params,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      serviceType: json['serviceType'] ?? '',
      isActive: json['isActive'] ?? false,
      basePath: json['basePath'] ?? '',
      params: Param.fromJson(json['params'] ?? {}),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'name': name,
      'description': description,
      'serviceType': serviceType,
      'isActive': isActive,
      'basePath': basePath,
      'params': params.toJson(),
    };
  }
}
