import 'package:uuid/uuid.dart';
import '../../../data/models/hair_profile.dart';
import '../../../data/models/treatment.dart';
import '../../../data/models/schedule.dart';

class GenerateScheduleUseCase {
  final int durationInWeeks;

  final List<Treatment> availableTreatments;

  GenerateScheduleUseCase({
    this.durationInWeeks = 8,
    required this.availableTreatments,
  });

  Schedule execute(HairProfile profile) {
    final scores = _calculateScores(profile);

    final startDate = DateTime.now();

    final endDate = DateTime.now().add(Duration(days: durationInWeeks * 7));

    final events = _generateEvents(profile, scores, startDate, durationInWeeks);

    return Schedule(
      id: const Uuid().v4(),
      hairProfileId: profile.id,
      startDate: startDate,
      endDate: endDate,
      events: events,
    );
  }

  Map<String, int> _calculateScores(HairProfile profile) {
    int hydrationPoints = 0;
    int nutritionPoints = 0;
    int reconstructionPoints = 0;

    switch (profile.porosity) {
      case HairPorosity.high:
        hydrationPoints += 3;
        break;
      case HairPorosity.medium:
        hydrationPoints += 2;
        break;
      case HairPorosity.low:
        nutritionPoints += 2;
        break;
    }

    switch (profile.elasticity) {
      case HairElasticity.low:
        reconstructionPoints += 3;
        break;
      case HairElasticity.medium:
        reconstructionPoints += 1;
        break;
      case HairElasticity.high:
        break;
    }

    switch (profile.damage) {
      case HairDamage.severe:
        reconstructionPoints += 5;
        break;
      case HairDamage.moderate:
        reconstructionPoints += 3;
        break;
      case HairDamage.light:
        reconstructionPoints += 1;
        break;
      case HairDamage.none:
        break;
    }

    switch (profile.curvature) {
      case HairCurvature.coily:
        hydrationPoints += 3;
        nutritionPoints += 3;
        break;
      case HairCurvature.curly:
        hydrationPoints += 2;
        nutritionPoints += 2;
        break;
      case HairCurvature.wavy:
        hydrationPoints += 1;
        nutritionPoints += 1;
        break;
      case HairCurvature.straight:
        break;
    }

    if (profile.usesHeatStyling) {
      reconstructionPoints += 2;
      hydrationPoints += 1;
    }

    switch (profile.oiliness) {
      case HairOiliness.dry:
        hydrationPoints += 2;
        nutritionPoints += 2;
        break;
      case HairOiliness.normal:
        break;
      case HairOiliness.oily:
        nutritionPoints -= 1;
        break;
    }

    return {
      'hydration': hydrationPoints,
      'nutrition': nutritionPoints,
      'reconstruction': reconstructionPoints,
    };
  }

  List<ScheduleEvent> _generateEvents(
      HairProfile profile,
      Map<String, int> scores,
      DateTime startDate,
      int durationInWeeks,
      ) {
    final events = <ScheduleEvent>[];
    final uuid = const Uuid();

    int hydrationFrequency = scores['hydration']! > 7 ? 3 : 7; // dias
    int nutritionFrequency = 7;

    int reconstructionFrequency;
    if (scores['reconstruction']! > 8) {
      reconstructionFrequency = 14;
    } else if (scores['reconstruction']! > 5) {
      reconstructionFrequency = 21;
    } else {
      reconstructionFrequency = 28;
    }

    TreatmentIntensity reconstructionIntensity;
    if (scores['reconstruction']! > 8) {
      reconstructionIntensity = TreatmentIntensity.intensive;
    } else if (scores['reconstruction']! > 5) {
      reconstructionIntensity = TreatmentIntensity.moderate;
    } else {
      reconstructionIntensity = TreatmentIntensity.light;
    }

    final hydrationTreatments = availableTreatments
        .where((t) => t.type == TreatmentType.hydration)
        .toList();

    final nutritionTreatments = availableTreatments
        .where((t) => t.type == TreatmentType.nutrition)
        .toList();

    final reconstructionTreatments = availableTreatments
        .where((t) =>
    t.type == TreatmentType.reconstruction &&
        t.intensity == reconstructionIntensity)
        .toList();

    final haircutTreatments = availableTreatments
        .where((t) => t.type == TreatmentType.haircut)
        .toList();

    final detoxTreatments = availableTreatments
        .where((t) => t.type == TreatmentType.detox)
        .toList();

    for (int day = 0; day < durationInWeeks * 7; day++) {
      final currentDate = startDate.add(Duration(days: day));

      if (day % hydrationFrequency == 0 && hydrationTreatments.isNotEmpty) {
        events.add(ScheduleEvent(
          id: uuid.v4(),
          treatmentId: hydrationTreatments.first.id,
          date: currentDate,
        ));
      }

      if (day % nutritionFrequency == 0 && nutritionTreatments.isNotEmpty) {
        if (day % hydrationFrequency != 0 || hydrationTreatments.isEmpty) {
          events.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: nutritionTreatments.first.id,
            date: currentDate,
          ));
        } else {
          events.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: nutritionTreatments.first.id,
            date: currentDate.add(const Duration(days: 1)),
          ));
        }
      }

      if (day % reconstructionFrequency == 0 && reconstructionTreatments.isNotEmpty) {
        if ((day % hydrationFrequency != 0 || hydrationTreatments.isEmpty) &&
            (day % nutritionFrequency != 0 || nutritionTreatments.isEmpty)) {
          events.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: reconstructionTreatments.first.id,
            date: currentDate,
          ));
        } else {
          events.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: reconstructionTreatments.first.id,
            date: currentDate.add(const Duration(days: 2)),
          ));
        }
      }
    }

    int haircutFrequency;
    switch (profile.length) {
      case HairLength.short:
        haircutFrequency = 30;
        break;
      case HairLength.medium:
        haircutFrequency = 60;
        break;
      case HairLength.long:
        haircutFrequency = 90;
        break;
    }

    final daysSinceLastCut = DateTime.now().difference(profile.lastCutDate).inDays;
    final daysUntilNextCut = haircutFrequency - daysSinceLastCut;

    if (daysUntilNextCut > 0 && daysUntilNextCut < durationInWeeks * 7 && haircutTreatments.isNotEmpty) {
      final nextCutDate = startDate.add(Duration(days: daysUntilNextCut));
      events.add(ScheduleEvent(
        id: uuid.v4(),
        treatmentId: haircutTreatments.first.id,
        date: nextCutDate,
      ));
    }

    if (detoxTreatments.isNotEmpty) {
      final detoxDate = startDate.add(const Duration(days: 30));
      events.add(ScheduleEvent(
        id: uuid.v4(),
        treatmentId: detoxTreatments.first.id,
        date: detoxDate,
      ));
    }

    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }
}