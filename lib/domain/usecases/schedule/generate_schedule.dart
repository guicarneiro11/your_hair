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
    final startDate = DateTime.now();
    final endDate = startDate.add(Duration(days: durationInWeeks * 7));

    final hairDiagnosis = _performHairDiagnosis(profile);
    final strategy = _createScientificStrategy(hairDiagnosis, profile);
    final events = _buildProfessionalSchedule(profile, strategy, startDate);

    return Schedule(
      id: const Uuid().v4(),
      hairProfileId: profile.id,
      startDate: startDate,
      endDate: endDate,
      events: events,
    );
  }

  HairDiagnosis _performHairDiagnosis(HairProfile profile) {
    int hydrationDeficit = _calculateHydrationDeficit(profile);
    int lipidDeficit = _calculateLipidDeficit(profile);
    int proteinDeficit = _calculateProteinDeficit(profile);
    bool needsHaircut = _assessHaircutNeed(profile);
    ScalpCondition scalpCondition = _assessScalpCondition(profile);

    return HairDiagnosis(
      hydrationDeficit: hydrationDeficit,
      lipidDeficit: lipidDeficit,
      proteinDeficit: proteinDeficit,
      needsHaircut: needsHaircut,
      scalpCondition: scalpCondition,
      overallHealthScore: _calculateOverallHealth(profile),
    );
  }

  int _calculateHydrationDeficit(HairProfile profile) {
    int deficit = 0;

    switch (profile.oiliness) {
      case HairOiliness.dry: deficit += 3; break;
      case HairOiliness.normal: deficit += 1; break;
      case HairOiliness.oily: deficit += 0; break;
    }

    if (profile.porosity == HairPorosity.high) deficit += 2;
    if (profile.porosity == HairPorosity.low) deficit -= 1;

    if (profile.usesHeatStyling) deficit += 2;
    if (profile.washFrequencyPerWeek > 5) deficit += 1;

    switch (profile.damage) {
      case HairDamage.severe: deficit += 2; break;
      case HairDamage.moderate: deficit += 1; break;
      default: break;
    }

    return deficit.clamp(0, 10);
  }

  int _calculateLipidDeficit(HairProfile profile) {
    int deficit = 0;

    switch (profile.curvature) {
      case HairCurvature.straight: deficit += 0; break;
      case HairCurvature.wavy: deficit += 1; break;
      case HairCurvature.curly: deficit += 2; break;
      case HairCurvature.coily: deficit += 3; break;
    }

    switch (profile.length) {
      case HairLength.short: deficit += 0; break;
      case HairLength.medium: deficit += 1; break;
      case HairLength.long: deficit += 2; break;
    }

    if (profile.oiliness == HairOiliness.dry) deficit += 1;

    switch (profile.damage) {
      case HairDamage.moderate: deficit += 1; break;
      case HairDamage.severe: deficit += 2; break;
      default: break;
    }

    return deficit.clamp(0, 10);
  }

  int _calculateProteinDeficit(HairProfile profile) {
    int deficit = 0;

    switch (profile.elasticity) {
      case HairElasticity.low: deficit += 3; break;
      case HairElasticity.medium: deficit += 0; break;
      case HairElasticity.high: deficit -= 1; break;
    }

    switch (profile.damage) {
      case HairDamage.severe: deficit += 3; break;
      case HairDamage.moderate: deficit += 2; break;
      case HairDamage.light: deficit += 1; break;
      default: break;
    }

    if (profile.lastChemicalTreatmentDate != null) {
      final daysSinceChemical = DateTime.now().difference(profile.lastChemicalTreatmentDate!).inDays;
      if (daysSinceChemical < 30) deficit += 2;
      else if (daysSinceChemical < 90) deficit += 1;
    }

    if (profile.usesHeatStyling) deficit += 1;

    if (profile.porosity == HairPorosity.high && profile.damage != HairDamage.none) {
      deficit += 1;
    }

    return deficit.clamp(0, 10);
  }

  bool _assessHaircutNeed(HairProfile profile) {
    final daysSinceLastCut = DateTime.now().difference(profile.lastCutDate).inDays;

    switch (profile.length) {
      case HairLength.short: return daysSinceLastCut >= 30;
      case HairLength.medium: return daysSinceLastCut >= 60;
      case HairLength.long: return daysSinceLastCut >= 90;
    }
  }

  ScalpCondition _assessScalpCondition(HairProfile profile) {
    if (profile.needsDandruffTreatment) return ScalpCondition.dandruff;
    if (profile.needsAntiHairLossTreatment) return ScalpCondition.hairLoss;
    if (profile.oiliness == HairOiliness.oily) return ScalpCondition.oily;
    if (profile.oiliness == HairOiliness.dry) return ScalpCondition.dry;
    return ScalpCondition.normal;
  }

  int _calculateOverallHealth(HairProfile profile) {
    int health = 100;

    switch (profile.damage) {
      case HairDamage.severe: health -= 40; break;
      case HairDamage.moderate: health -= 25; break;
      case HairDamage.light: health -= 10; break;
      default: break;
    }

    if (profile.usesHeatStyling) health -= 15;
    if (profile.washFrequencyPerWeek > 5) health -= 10;
    if (profile.elasticity == HairElasticity.low) health -= 20;
    if (profile.porosity == HairPorosity.high) health -= 10;

    return health.clamp(0, 100);
  }

  TreatmentStrategy _createScientificStrategy(HairDiagnosis diagnosis, HairProfile profile) {
    List<TreatmentPriority> priorities = [];

    if (diagnosis.hydrationDeficit > 0) {
      priorities.add(TreatmentPriority(
        type: TreatmentType.hydration,
        urgency: diagnosis.hydrationDeficit,
        weeklyFrequency: _calculateHydrationFrequency(diagnosis, profile),
      ));
    }

    if (diagnosis.lipidDeficit > 0) {
      priorities.add(TreatmentPriority(
        type: TreatmentType.nutrition,
        urgency: diagnosis.lipidDeficit,
        weeklyFrequency: _calculateNutritionFrequency(diagnosis, profile),
      ));
    }

    if (diagnosis.proteinDeficit > 0) {
      priorities.add(TreatmentPriority(
        type: TreatmentType.reconstruction,
        urgency: diagnosis.proteinDeficit,
        weeklyFrequency: _calculateReconstructionFrequency(diagnosis, profile),
      ));
    }

    priorities.sort((a, b) => b.urgency.compareTo(a.urgency));

    return TreatmentStrategy(
      priorities: priorities,
      washDaysPerWeek: profile.washFrequencyPerWeek,
      needsUmectacao: profile.wantsUmectacao,
      needsAcidificante: profile.usesAcidificante,
      needsTonalizacao: profile.wantsTonalizacao,
      needsHaircut: diagnosis.needsHaircut,
      scalpTreatments: _getScalpTreatments(diagnosis.scalpCondition, profile),
    );
  }

  int _calculateHydrationFrequency(HairDiagnosis diagnosis, HairProfile profile) {
    if (diagnosis.hydrationDeficit >= 5) {
      return (profile.washFrequencyPerWeek * 0.6).round();
    } else if (diagnosis.hydrationDeficit >= 3) {
      return (profile.washFrequencyPerWeek * 0.4).round();
    } else {
      return (profile.washFrequencyPerWeek * 0.3).round();
    }
  }

  int _calculateNutritionFrequency(HairDiagnosis diagnosis, HairProfile profile) {
    int baseFreq = profile.curvature == HairCurvature.coily ||
        profile.curvature == HairCurvature.curly ? 2 : 1;

    if (diagnosis.lipidDeficit >= 5) {
      return baseFreq + 1;
    } else if (diagnosis.lipidDeficit >= 3) {
      return baseFreq;
    } else {
      return (baseFreq * 0.5).round();
    }
  }

  int _calculateReconstructionFrequency(HairDiagnosis diagnosis, HairProfile profile) {
    if (diagnosis.proteinDeficit >= 6) {
      return 2;
    } else if (diagnosis.proteinDeficit >= 3) {
      return 1;
    } else {
      return 0;
    }
  }

  List<String> _getScalpTreatments(ScalpCondition condition, HairProfile profile) {
    final treatments = <String>[];

    switch (condition) {
      case ScalpCondition.dandruff:
        treatments.add('tratamento_caspa');
        break;
      case ScalpCondition.hairLoss:
        treatments.add('tratamento_antiqueda');
        break;
      case ScalpCondition.oily:
        treatments.add('detox');
        break;
      default:
        break;
    }

    return treatments;
  }

  List<ScheduleEvent> _buildProfessionalSchedule(
      HairProfile profile,
      TreatmentStrategy strategy,
      DateTime startDate
      ) {
    final uuid = const Uuid();
    final events = <ScheduleEvent>[];

    final washDays = _generateWashSchedule(
        strategy.washDaysPerWeek,
        startDate,
        durationInWeeks
    );

    final treatmentCycle = _createTreatmentCycle(strategy);
    int cycleIndex = 0;

    for (int i = 0; i < washDays.length; i++) {
      final washDay = washDays[i];
      final treatmentType = treatmentCycle[cycleIndex % treatmentCycle.length];

      if (strategy.needsUmectacao && _shouldDoUmectacao(i, treatmentType)) {
        final umectacaoDay = DateTime(
            washDay.year,
            washDay.month,
            washDay.day - 1,
            20,
            0
        );
        if (umectacaoDay.isAfter(DateTime.now())) {
          events.add(_createEvent(uuid, 'umectacao', umectacaoDay));
        }
      }

      final treatment = _findTreatmentByType(treatmentType);
      if (treatment != null) {
        events.add(_createEvent(uuid, treatment.id, washDay));

        if (treatmentType == TreatmentType.reconstruction && strategy.needsAcidificante) {
          final acidificanteTime = DateTime(
            washDay.year,
            washDay.month,
            washDay.day,
            washDay.hour,
            washDay.minute + 30,
          );
          events.add(_createEvent(uuid, 'acidificante', acidificanteTime));
        }
      }

      if (strategy.needsTonalizacao && i > 0 && i % 6 == 0) {
        events.add(_createEvent(uuid, 'tonalizacao', washDay));
      }

      cycleIndex++;
    }

    if (strategy.needsHaircut) {
      final cutDate = _calculateOptimalCutDate(profile, startDate);
      events.add(_createEvent(uuid, 'haircut', cutDate));
    }

    events.addAll(_addScalpTreatments(uuid, strategy, washDays));

    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }

  List<TreatmentType> _createTreatmentCycle(TreatmentStrategy strategy) {
    final cycle = <TreatmentType>[];
    final priorities = strategy.priorities;

    if (priorities.isEmpty) return [TreatmentType.hydration];

    for (final priority in priorities) {
      for (int i = 0; i < priority.weeklyFrequency; i++) {
        cycle.add(priority.type);
      }
    }

    while (cycle.length < 4) {
      cycle.add(priorities.first.type);
    }

    return cycle;
  }

  bool _shouldDoUmectacao(int washIndex, TreatmentType treatmentType) {
    return washIndex % 3 == 0 &&
        (treatmentType == TreatmentType.hydration ||
            treatmentType == TreatmentType.nutrition) &&
        treatmentType != TreatmentType.reconstruction;
  }

  List<DateTime> _generateWashSchedule(int washesPerWeek, DateTime startDate, int weeks) {
    final washDays = <DateTime>[];

    final patterns = {
      1: [0],
      2: [0, 3],
      3: [0, 2, 4],
      4: [0, 2, 4, 6],
      5: [1, 2, 3, 4, 5],
      6: [0, 1, 2, 4, 5, 6],
      7: [0, 1, 2, 3, 4, 5, 6],
    };

    final pattern = patterns[washesPerWeek] ?? patterns[3]!;

    for (int week = 0; week < weeks; week++) {
      for (int dayOfWeek in pattern) {
        final washDay = startDate.add(Duration(days: week * 7 + dayOfWeek));
        washDays.add(washDay);
      }
    }

    return washDays;
  }

  DateTime _calculateOptimalCutDate(HairProfile profile, DateTime startDate) {
    final daysSinceLastCut = DateTime.now().difference(profile.lastCutDate).inDays;

    final intervalMap = {
      HairLength.short: 30,
      HairLength.medium: 60,
      HairLength.long: 90,
    };

    final interval = intervalMap[profile.length]!;

    if (daysSinceLastCut >= interval) {
      return startDate.add(const Duration(days: 7));
    } else {
      return profile.lastCutDate.add(Duration(days: interval));
    }
  }

  List<ScheduleEvent> _addScalpTreatments(
      Uuid uuid,
      TreatmentStrategy strategy,
      List<DateTime> washDays
      ) {
    final events = <ScheduleEvent>[];

    for (final treatmentId in strategy.scalpTreatments) {
      final treatment = availableTreatments.firstWhere(
            (t) => t.id == treatmentId,
        orElse: () => availableTreatments.first,
      );

      for (int i = 0; i < washDays.length; i += treatment.recommendedFrequencyDays ~/ 7) {
        if (i < washDays.length) {
          events.add(_createEvent(uuid, treatment.id, washDays[i]));
        }
      }
    }

    return events;
  }

  Treatment? _findTreatmentByType(TreatmentType type) {
    try {
      return availableTreatments.firstWhere((t) => t.type == type);
    } catch (_) {
      return null;
    }
  }

  ScheduleEvent _createEvent(Uuid uuid, String treatmentId, DateTime date) {
    DateTime finalDate = date;
    if (date.isBefore(DateTime.now())) {
      finalDate = DateTime.now().add(const Duration(hours: 2));
    }

    return ScheduleEvent(
      id: uuid.v4(),
      treatmentId: treatmentId,
      date: finalDate,
    );
  }
}

class HairDiagnosis {
  final int hydrationDeficit;
  final int lipidDeficit;
  final int proteinDeficit;
  final bool needsHaircut;
  final ScalpCondition scalpCondition;
  final int overallHealthScore;

  HairDiagnosis({
    required this.hydrationDeficit,
    required this.lipidDeficit,
    required this.proteinDeficit,
    required this.needsHaircut,
    required this.scalpCondition,
    required this.overallHealthScore,
  });
}

class TreatmentPriority {
  final TreatmentType type;
  final int urgency;
  final int weeklyFrequency;

  TreatmentPriority({
    required this.type,
    required this.urgency,
    required this.weeklyFrequency,
  });
}

class TreatmentStrategy {
  final List<TreatmentPriority> priorities;
  final int washDaysPerWeek;
  final bool needsUmectacao;
  final bool needsAcidificante;
  final bool needsTonalizacao;
  final bool needsHaircut;
  final List<String> scalpTreatments;

  TreatmentStrategy({
    required this.priorities,
    required this.washDaysPerWeek,
    required this.needsUmectacao,
    required this.needsAcidificante,
    required this.needsTonalizacao,
    required this.needsHaircut,
    required this.scalpTreatments,
  });
}

enum ScalpCondition {
  normal,
  oily,
  dry,
  dandruff,
  hairLoss,
}