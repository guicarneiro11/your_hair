import 'package:flutter/foundation.dart';
import '../../../../data/models/hair_profile.dart';
import '../../../../data/models/schedule.dart';
import '../../../../data/models/treatment.dart';
import '../../../../domain/repositories/hair_profile_repository.dart';
import '../../../../domain/repositories/schedule_repository.dart';
import '../../../../domain/repositories/treatment_repository.dart';
import '../../../../domain/usecases/schedule/generate_schedule.dart';

class HomeProvider with ChangeNotifier {
  final HairProfileRepository _profileRepository;
  final ScheduleRepository _scheduleRepository;
  final TreatmentRepository _treatmentRepository;

  HairProfile? _profile;
  Schedule? _activeSchedule;
  List<Treatment> _treatments = [];

  bool _isLoading = false;
  String? _error;

  HomeProvider({
    required HairProfileRepository profileRepository,
    required ScheduleRepository scheduleRepository,
    required TreatmentRepository treatmentRepository,
  })  : _profileRepository = profileRepository,
        _scheduleRepository = scheduleRepository,
        _treatmentRepository = treatmentRepository {
    _loadTreatments();
  }

  HairProfile? get profile => _profile;
  Schedule? get activeSchedule => _activeSchedule;
  List<Treatment> get treatments => _treatments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _loadTreatments() async {
    try {
      _treatments = await _treatmentRepository.getAllTreatments();
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<void> loadSchedule() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _profileRepository.getProfile();

      if (_profile != null) {
        _activeSchedule = await _scheduleRepository.getActiveSchedule();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> generateSchedule() async {
    if (_profile == null) {
      _error = 'Perfil não encontrado. Por favor, crie um perfil primeiro.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final useCase = GenerateScheduleUseCase(
        availableTreatments: _treatments,
      );

      final newSchedule = useCase.execute(_profile!);

      await _scheduleRepository.saveSchedule(newSchedule);

      _activeSchedule = newSchedule;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> regenerateSchedule() async {
    return generateSchedule();
  }

  List<ScheduleEvent> getEventsForDay(DateTime day) {
    if (_activeSchedule == null) {
      return [];
    }

    final normalizedDay = DateTime(day.year, day.month, day.day);

    return _activeSchedule!.events.where((event) {
      final eventDate = DateTime(event.date.year, event.date.month, event.date.day);
      return eventDate.isAtSameMomentAs(normalizedDay);
    }).toList();
  }

  Treatment? getTreatmentById(String id) {
    try {
      return _treatments.firstWhere((treatment) => treatment.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateEventCompletion(ScheduleEvent event, bool isCompleted) async {
    if (_activeSchedule == null) {
      return;
    }

    try {
      final updatedEvent = event.copyWith(
        isCompleted: isCompleted,
        completedDate: isCompleted ? DateTime.now() : null,
      );

      final eventIndex = _activeSchedule!.events.indexWhere((e) => e.id == event.id);

      if (eventIndex != -1) {
        _activeSchedule!.events[eventIndex] = updatedEvent;

        await _scheduleRepository.updateScheduleEvent(
          _activeSchedule!.id,
          updatedEvent,
        );

        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}