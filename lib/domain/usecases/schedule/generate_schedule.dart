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
      case HairOiliness.dry: deficit += 4; break;
      case HairOiliness.normal: deficit += 2; break;
      case HairOiliness.oily: deficit += 1; break;
    }

    if (profile.porosity == HairPorosity.high) deficit += 3;
    if (profile.porosity == HairPorosity.medium) deficit += 1;

    if (profile.usesHeatStyling) deficit += 2;
    if (profile.washFrequencyPerWeek > 4) deficit += 2;

    switch (profile.damage) {
      case HairDamage.severe: deficit += 3; break;
      case HairDamage.moderate: deficit += 2; break;
      case HairDamage.light: deficit += 1; break;
      default: break;
    }

    return deficit.clamp(0, 10);
  }

  int _calculateLipidDeficit(HairProfile profile) {
    int deficit = 0;

    switch (profile.curvature) {
      case HairCurvature.straight: deficit += 0; break;
      case HairCurvature.wavy: deficit += 1; break;
      case HairCurvature.curly: deficit += 3; break;
      case HairCurvature.coily: deficit += 4; break;
    }

    switch (profile.length) {
      case HairLength.short: deficit += 0; break;
      case HairLength.medium: deficit += 1; break;
      case HairLength.long: deficit += 2; break;
    }

    if (profile.oiliness == HairOiliness.dry) deficit += 2;

    switch (profile.damage) {
      case HairDamage.moderate: deficit += 1; break;
      case HairDamage.severe: deficit += 2; break;
      default: break;
    }

    if (profile.porosity == HairPorosity.high) deficit += 1;

    return deficit.clamp(0, 10);
  }

  int _calculateProteinDeficit(HairProfile profile) {
    int deficit = 0;

    switch (profile.elasticity) {
      case HairElasticity.low: deficit += 4; break;
      case HairElasticity.medium: deficit += 1; break;
      case HairElasticity.high: deficit += 0; break;
    }

    switch (profile.damage) {
      case HairDamage.severe: deficit += 3; break;
      case HairDamage.moderate: deficit += 2; break;
      case HairDamage.light: deficit += 1; break;
      default: break;
    }

    if (profile.lastChemicalTreatmentDate != null) {
      final daysSinceChemical = DateTime.now().difference(profile.lastChemicalTreatmentDate!).inDays;
      if (daysSinceChemical < 30) deficit += 3;
      else if (daysSinceChemical < 90) deficit += 2;
      else if (daysSinceChemical < 180) deficit += 1;
    }

    if (profile.usesHeatStyling) deficit += 1;

    if (profile.porosity == HairPorosity.high) deficit += 2;

    return deficit.clamp(0, 10);
  }

  bool _assessHaircutNeed(HairProfile profile) {
    final daysSinceLastCut = DateTime.now().difference(profile.lastCutDate).inDays;

    switch (profile.length) {
      case HairLength.short: return daysSinceLastCut >= 45;
      case HairLength.medium: return daysSinceLastCut >= 75;
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
      case HairDamage.severe: health -= 30; break;
      case HairDamage.moderate: health -= 20; break;
      case HairDamage.light: health -= 10; break;
      default: break;
    }

    if (profile.usesHeatStyling) health -= 10;
    if (profile.washFrequencyPerWeek > 5) health -= 10;
    if (profile.elasticity == HairElasticity.low) health -= 15;
    if (profile.porosity == HairPorosity.high) health -= 10;

    return health.clamp(0, 100);
  }

  TreatmentStrategy _createScientificStrategy(HairDiagnosis diagnosis, HairProfile profile) {
    List<TreatmentPriority> priorities = [];

    int totalDeficit = diagnosis.hydrationDeficit + diagnosis.lipidDeficit + diagnosis.proteinDeficit;

    double hydrationRatio = totalDeficit > 0 ? diagnosis.hydrationDeficit / totalDeficit : 0.33;
    double nutritionRatio = totalDeficit > 0 ? diagnosis.lipidDeficit / totalDeficit : 0.33;
    double reconstructionRatio = totalDeficit > 0 ? diagnosis.proteinDeficit / totalDeficit : 0.34;

    if (diagnosis.overallHealthScore >= 80) {
      hydrationRatio = 0.5;
      nutritionRatio = 0.3;
      reconstructionRatio = 0.2;
    }

    int treatmentsPerWeek = _calculateTreatmentsPerWeek(profile);

    if (hydrationRatio > 0) {
      priorities.add(TreatmentPriority(
        type: TreatmentType.hydration,
        urgency: diagnosis.hydrationDeficit,
        weeklyFrequency: (treatmentsPerWeek * hydrationRatio).round(),
      ));
    }

    if (nutritionRatio > 0) {
      priorities.add(TreatmentPriority(
        type: TreatmentType.nutrition,
        urgency: diagnosis.lipidDeficit,
        weeklyFrequency: (treatmentsPerWeek * nutritionRatio).round(),
      ));
    }

    if (reconstructionRatio > 0 && diagnosis.proteinDeficit > 2) {
      int reconstructionFreq = (treatmentsPerWeek * reconstructionRatio).round();
      if (reconstructionFreq == 0 && diagnosis.proteinDeficit > 4) {
        reconstructionFreq = 1;
      }
      priorities.add(TreatmentPriority(
        type: TreatmentType.reconstruction,
        urgency: diagnosis.proteinDeficit,
        weeklyFrequency: reconstructionFreq,
      ));
    }

    priorities.sort((a, b) => b.urgency.compareTo(a.urgency));

    return TreatmentStrategy(
      priorities: priorities,
      washDaysPerWeek: profile.washFrequencyPerWeek,
      needsUmectacao: _shouldDoUmectacao(profile),
      umectacaoFrequencyDays: _calculateUmectacaoFrequency(profile),
      needsAcidificante: profile.usesAcidificante,
      needsTonalizacao: profile.wantsTonalizacao,
      needsHaircut: diagnosis.needsHaircut,
      scalpTreatments: _getScalpTreatments(diagnosis.scalpCondition, profile),
    );
  }

  int _calculateTreatmentsPerWeek(HairProfile profile) {
    return profile.washFrequencyPerWeek.clamp(1, 7);
  }

  bool _shouldDoUmectacao(HairProfile profile) {
    if (!profile.wantsUmectacao) return false;

    return profile.curvature == HairCurvature.curly ||
        profile.curvature == HairCurvature.coily ||
        profile.oiliness == HairOiliness.dry ||
        profile.damage == HairDamage.moderate ||
        profile.damage == HairDamage.severe;
  }

  int _calculateUmectacaoFrequency(HairProfile profile) {
    if (!profile.wantsUmectacao) return 0;

    switch (profile.curvature) {
      case HairCurvature.straight:
        return profile.oiliness == HairOiliness.dry ? 14 : 21;
      case HairCurvature.wavy:
        return profile.oiliness == HairOiliness.dry ? 10 : 14;
      case HairCurvature.curly:
        return 7;
      case HairCurvature.coily:
        return 7;
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
        treatments.add('exfoliation');
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

    final treatmentCycle = _createBalancedTreatmentCycle(strategy);
    int cycleIndex = 0;

    DateTime? lastUmectacaoDate;
    DateTime? lastDetoxDate;
    DateTime? lastTonalizacaoDate;
    int reconstructionCount = 0;

    for (int i = 0; i < washDays.length; i++) {
      final washDay = washDays[i];

      if (strategy.needsUmectacao && strategy.umectacaoFrequencyDays > 0) {
        if (lastUmectacaoDate == null ||
            washDay.difference(lastUmectacaoDate).inDays >= strategy.umectacaoFrequencyDays) {
          final umectacaoDay = DateTime(
              washDay.year,
              washDay.month,
              washDay.day - 1,
              20,
              0
          );
          if (umectacaoDay.isAfter(DateTime.now())) {
            events.add(_createEvent(uuid, 'umectacao', umectacaoDay));
            lastUmectacaoDate = washDay;
          }
        }
      }

      if (cycleIndex < treatmentCycle.length) {
        final treatmentType = treatmentCycle[cycleIndex % treatmentCycle.length];
        final treatment = _findTreatmentByType(treatmentType);

        if (treatment != null) {
          if (treatmentType == TreatmentType.reconstruction) {
            reconstructionCount++;
            if (reconstructionCount > 2 && reconstructionCount % 3 == 0) {
              cycleIndex++;
              if (cycleIndex < treatmentCycle.length) {
                final alternativeTreatment = _findTreatmentByType(treatmentCycle[cycleIndex % treatmentCycle.length]);
                if (alternativeTreatment != null) {
                  events.add(_createEvent(uuid, alternativeTreatment.id, washDay));
                }
              }
            } else {
              events.add(_createEvent(uuid, treatment.id, washDay));

              if (strategy.needsAcidificante) {
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
          } else {
            events.add(_createEvent(uuid, treatment.id, washDay));
          }
        }
      }

      if (strategy.needsTonalizacao) {
        if (lastTonalizacaoDate == null ||
            washDay.difference(lastTonalizacaoDate).inDays >= 15) {
          events.add(_createEvent(uuid, 'tonalizacao', washDay));
          lastTonalizacaoDate = washDay;
        }
      }

      if ((lastDetoxDate == null || washDay.difference(lastDetoxDate).inDays >= 30) &&
          (profile.oiliness == HairOiliness.oily || i % 8 == 0)) {
        events.add(_createEvent(uuid, 'detox', washDay));
        lastDetoxDate = washDay;
      }

      cycleIndex++;
    }

    if (strategy.needsHaircut) {
      final cutDate = _calculateOptimalCutDate(profile, startDate);
      events.add(_createEvent(uuid, 'haircut', cutDate));
    }

    events.addAll(_addSpecialTreatments(uuid, profile, washDays));
    events.addAll(_addScalpTreatments(uuid, strategy, washDays));
    events.addAll(_addMaintenanceTreatments(uuid, profile, startDate));

    events.sort((a, b) => a.date.compareTo(b.date));
    return events;
  }

  List<TreatmentType> _createBalancedTreatmentCycle(TreatmentStrategy strategy) {
    final cycle = <TreatmentType>[];

    for (final priority in strategy.priorities) {
      for (int i = 0; i < priority.weeklyFrequency; i++) {
        cycle.add(priority.type);
      }
    }

    if (cycle.isEmpty) {
      cycle.add(TreatmentType.hydration);
    }

    cycle.sort((a, b) {
      final priorityA = strategy.priorities.firstWhere((p) => p.type == a).urgency;
      final priorityB = strategy.priorities.firstWhere((p) => p.type == b).urgency;
      return priorityB.compareTo(priorityA);
    });

    final balancedCycle = <TreatmentType>[];
    int hydrationCount = 0;
    int nutritionCount = 0;
    int reconstructionCount = 0;

    for (final type in cycle) {
      switch (type) {
        case TreatmentType.hydration:
          hydrationCount++;
          break;
        case TreatmentType.nutrition:
          nutritionCount++;
          break;
        case TreatmentType.reconstruction:
          reconstructionCount++;
          break;
        default:
          break;
      }
    }

    while (hydrationCount > 0 || nutritionCount > 0 || reconstructionCount > 0) {
      if (hydrationCount > 0) {
        balancedCycle.add(TreatmentType.hydration);
        hydrationCount--;
      }
      if (nutritionCount > 0) {
        balancedCycle.add(TreatmentType.nutrition);
        nutritionCount--;
      }
      if (reconstructionCount > 0 && balancedCycle.length % 3 == 2) {
        balancedCycle.add(TreatmentType.reconstruction);
        reconstructionCount--;
      } else if (hydrationCount > 0) {
        balancedCycle.add(TreatmentType.hydration);
        hydrationCount--;
      } else if (nutritionCount > 0) {
        balancedCycle.add(TreatmentType.nutrition);
        nutritionCount--;
      }
    }

    return balancedCycle;
  }

  List<DateTime> _generateWashSchedule(int washesPerWeek, DateTime startDate, int weeks) {
    final washDays = <DateTime>[];

    final patterns = {
      1: [3],
      2: [0, 3],
      3: [0, 2, 5],
      4: [0, 2, 4, 6],
      5: [0, 1, 3, 4, 6],
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
      HairLength.short: 45,
      HairLength.medium: 75,
      HairLength.long: 90,
    };

    final interval = intervalMap[profile.length]!;

    if (daysSinceLastCut >= interval) {
      return startDate.add(const Duration(days: 7));
    } else {
      final nextCutDate = profile.lastCutDate.add(Duration(days: interval));
      if (nextCutDate.isBefore(startDate.add(Duration(days: durationInWeeks * 7)))) {
        return nextCutDate;
      }
    }

    return startDate.add(Duration(days: durationInWeeks * 7 + 7));
  }

  List<ScheduleEvent> _addSpecialTreatments(
      Uuid uuid,
      HairProfile profile,
      List<DateTime> washDays
      ) {
    final events = <ScheduleEvent>[];

    if (profile.wantsHairColorRetouching) {
      final colorDate = washDays.firstWhere(
            (date) => date.isAfter(DateTime.now().add(const Duration(days: 30))),
        orElse: () => washDays.last,
      );
      events.add(_createEvent(uuid, 'retoque_cor', colorDate));
    }

    if (profile.wantsHighlightRetouching) {
      final highlightDate = washDays.firstWhere(
            (date) => date.isAfter(DateTime.now().add(const Duration(days: 60))),
        orElse: () => washDays.last,
      );
      events.add(_createEvent(uuid, 'retoque_luzes', highlightDate));
    }

    if (profile.wantsStraighteningRetouching) {
      final straighteningDate = washDays.firstWhere(
            (date) => date.isAfter(DateTime.now().add(const Duration(days: 90))),
        orElse: () => washDays.last,
      );
      events.add(_createEvent(uuid, 'retoque_alisamento', straighteningDate));
    }

    return events;
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

      int frequency = 7;
      if (treatmentId == 'tratamento_caspa') frequency = 3;
      if (treatmentId == 'tratamento_antiqueda') frequency = 7;
      if (treatmentId == 'detox') frequency = 30;
      if (treatmentId == 'exfoliation') frequency = 30;

      for (int i = 0; i < washDays.length; i += (frequency * 7 ~/ strategy.washDaysPerWeek).clamp(1, washDays.length)) {
        if (i < washDays.length) {
          events.add(_createEvent(uuid, treatment.id, washDays[i]));
        }
      }
    }

    return events;
  }

  List<ScheduleEvent> _addMaintenanceTreatments(
      Uuid uuid,
      HairProfile profile,
      DateTime startDate
      ) {
    final events = <ScheduleEvent>[];

    if (profile.hasHairExtensions) {
      for (int week = 5; week < durationInWeeks; week += 6) {
        final maintenanceDate = startDate.add(Duration(days: week * 7));
        events.add(_createEvent(uuid, 'manutencao_megahair', maintenanceDate));
      }
    }

    if (profile.hasBraids) {
      for (int week = 4; week < durationInWeeks; week += 6) {
        final maintenanceDate = startDate.add(Duration(days: week * 7));
        events.add(_createEvent(uuid, 'manutencao_trancas', maintenanceDate));
      }
    }

    if (profile.hasDreads) {
      for (int week = 4; week < durationInWeeks; week += 5) {
        final maintenanceDate = startDate.add(Duration(days: week * 7));
        events.add(_createEvent(uuid, 'manutencao_dreads', maintenanceDate));
      }
    }

    for (int week = 0; week < durationInWeeks; week++) {
      final photoDate = startDate.add(Duration(days: week * 7));
      if (week % 4 == 0) {
        events.add(_createEvent(uuid, 'foto_acompanhamento', photoDate));
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
  final int umectacaoFrequencyDays;
  final bool needsAcidificante;
  final bool needsTonalizacao;
  final bool needsHaircut;
  final List<String> scalpTreatments;

  TreatmentStrategy({
    required this.priorities,
    required this.washDaysPerWeek,
    required this.needsUmectacao,
    this.umectacaoFrequencyDays = 14,
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