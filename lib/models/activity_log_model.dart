// lib/models/activity_log_model.dart
class ActivityLog {
  final String id;
  final String actorId;
  final String actorUsername;
  final String actionType;
  final String? targetType;
  final String? targetId;
  final String? targetName;
  final DateTime createdAt;
  // final dynamic details; // Optional

  ActivityLog({
    required this.id,
    required this.actorId,
    required this.actorUsername,
    required this.actionType,
    this.targetType,
    this.targetId,
    this.targetName,
    required this.createdAt,
    // this.details,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['_id'] ?? '',
      actorId: json['actorId'] ?? '',
      actorUsername: json['actorUsername'] ?? 'Unknown Actor',
      actionType: json['actionType'] ?? 'UNKNOWN_ACTION',
      targetType: json['targetType'],
      targetId: json['targetId'],
      targetName: json['targetName'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      // details: json['details'],
    );
  }
}