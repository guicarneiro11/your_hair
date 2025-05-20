import 'package:hive/hive.dart';

part 'schedule.g.dart';

@HiveType(typeId: 11)
class ScheduleEvent extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String treatmentId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime? completedDate;

  @HiveField(5)
  int? userRating;

  @HiveField(6)
  String? userNotes;

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
}

@HiveType(typeId: 12)
class Schedule extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String hairProfileId;

  @HiveField(2)
  DateTime startDate;

  @HiveField(3)
  DateTime endDate;

  @HiveField(4)
  List<ScheduleEvent> events;

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
}