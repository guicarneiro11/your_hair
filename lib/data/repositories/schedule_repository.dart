import '../models/schedule.dart';
import '../data_sources/local/hive_data_source.dart';
import '../../domain/repositories/schedule_repository.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  @override
  Future<List<Schedule>> getSchedules() async {
    final box = HiveDataSource.getScheduleBox();
    return box.values.toList();
  }

  @override
  Future<Schedule?> getActiveSchedule() async {
    final box = HiveDataSource.getScheduleBox();

    if (box.isEmpty) {
      return null;
    }

    final schedules = box.values.toList();
    schedules.sort((a, b) => b.startDate.compareTo(a.startDate));

    return schedules.first;
  }

  @override
  Future<Schedule?> getScheduleById(String id) async {
    final box = HiveDataSource.getScheduleBox();
    return box.get(id);
  }

  @override
  Future<void> saveSchedule(Schedule schedule) async {
    final box = HiveDataSource.getScheduleBox();
    await box.put(schedule.id, schedule);
  }

  @override
  Future<void> updateSchedule(Schedule schedule) async {
    final box = HiveDataSource.getScheduleBox();
    await box.put(schedule.id, schedule);
  }

  @override
  Future<void> updateScheduleEvent(String scheduleId, ScheduleEvent event) async {
    final box = HiveDataSource.getScheduleBox();
    final schedule = box.get(scheduleId);

    if (schedule != null) {
      final eventIndex = schedule.events.indexWhere((e) => e.id == event.id);

      if (eventIndex != -1) {
        schedule.events[eventIndex] = event;
        await box.put(scheduleId, schedule);
      }
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    final box = HiveDataSource.getScheduleBox();
    await box.delete(id);
  }
}