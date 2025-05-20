import 'package:flutter/foundation.dart';

class ScheduleEvent {
  final String id;
  final String treatmentId;
  final DateTime date;
  final bool isCompleted;
  final DateTime? completedDate;
  final int? userRating;
  final String? userNotes;

  ScheduleEvent({
    required this.id,
    required this.treatmentId,
    required this.date,
    this.isCompleted = false,
    this.completedDate,
    this.userRating,
    this.userNotes,
  });

  ScheduleEvent copyWith({
    String? id,
    String? treatmentId,
    DateTime? date,
    bool? isCompleted,
    DateTime? completedDate,
    int? userRating,
    String? userNotes,
  }) {
    return ScheduleEvent(
      id: id ?? this.id,
      treatmentId: treatmentId ?? this.treatmentId,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      completedDate: completedDate ?? this.completedDate,
      userRating: userRating ?? this.userRating,
      userNotes: userNotes ?? this.userNotes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'treatmentId': treatmentId,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'completedDate': completedDate?.toIso8601String(),
      'userRating': userRating,
      'userNotes': userNotes,
    };
  }

  factory ScheduleEvent.fromJson(Map<String, dynamic> json) {
    return ScheduleEvent(
      id: json['id'],
      treatmentId: json['treatmentId'],
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'],
      completedDate: json['completedDate'] != null ? DateTime.parse(json['completedDate']) : null,
      userRating: json['userRating'],
      userNotes: json['userNotes'],
    );
  }
}

class Schedule {
  final String id;
  final String hairProfileId;
  final DateTime startDate;
  final DateTime endDate;
  final List<ScheduleEvent> events;

  Schedule({
    required this.id,
    required this.hairProfileId,
    required this.startDate,
    required this.endDate,
    required this.events,
  });

  Schedule copyWith({
    String? id,
    String? hairProfileId,
    DateTime? startDate,
    DateTime? endDate,
    List<ScheduleEvent>? events,
  }) {
    return Schedule(
      id: id ?? this.id,
      hairProfileId: hairProfileId ?? this.hairProfileId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      events: events ?? this.events,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hairProfileId': hairProfileId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'events': events.map((e) => e.toJson()).toList(),
    };
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      hairProfileId: json['hairProfileId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      events: (json['events'] as List)
          .map((e) => ScheduleEvent.fromJson(e))
          .toList(),
    );
  }
}