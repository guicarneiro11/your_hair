import '../../data/models/schedule.dart';

abstract class ScheduleRepository {
  Future<List<Schedule>> getSchedules();
  Future<Schedule?> getActiveSchedule();
  Future<Schedule?> getScheduleById(String id);
  Future<void> saveSchedule(Schedule schedule);
  Future<void> updateSchedule(Schedule schedule);
  Future<void> updateScheduleEvent(String scheduleId, ScheduleEvent event);
  Future<void> deleteSchedule(String id);
}