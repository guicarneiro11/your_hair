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
        hydrationPoints += 5;
        break;
      case HairPorosity.medium:
        hydrationPoints += 2;
        break;
      case HairPorosity.low:
        nutritionPoints += 3;
        break;
    }

    switch (profile.elasticity) {
      case HairElasticity.low:
        reconstructionPoints += 5;
        break;
      case HairElasticity.medium:
        reconstructionPoints += 2;
        break;
      case HairElasticity.high:
        break;
    }

    switch (profile.damage) {
      case HairDamage.severe:
        reconstructionPoints += 5;
        hydrationPoints += 3;
        break;
      case HairDamage.moderate:
        reconstructionPoints += 3;
        hydrationPoints += 2;
        break;
      case HairDamage.light:
        reconstructionPoints += 1;
        break;
      case HairDamage.none:
        break;
    }

    switch (profile.curvature) {
      case HairCurvature.coily:
        hydrationPoints += 4;
        nutritionPoints += 4;
        break;
      case HairCurvature.curly:
        hydrationPoints += 3;
        nutritionPoints += 3;
        break;
      case HairCurvature.wavy:
        hydrationPoints += 2;
        nutritionPoints += 1;
        break;
      case HairCurvature.straight:
        break;
    }
    if (profile.usesHeatStyling) {
      reconstructionPoints += 3;
      hydrationPoints += 2;
    }

    switch (profile.oiliness) {
      case HairOiliness.dry:
        hydrationPoints += 3;
        nutritionPoints += 3;
        break;
      case HairOiliness.normal:
        break;
      case HairOiliness.oily:
        nutritionPoints -= 2;
        hydrationPoints -= 1;
        break;
    }

    switch (profile.thickness) {
      case HairThickness.fine:
        reconstructionPoints += 2;
        nutritionPoints -= 1;
        break;
      case HairThickness.medium:
        break;
      case HairThickness.thick:
        nutritionPoints += 2;
        hydrationPoints += 1;
        break;
    }

    if (profile.washFrequencyPerWeek > 4) {
      hydrationPoints += 3;
      nutritionPoints += 2;
    } else if (profile.washFrequencyPerWeek <= 2) {
      hydrationPoints -= 1;
    }

    if (profile.wantsUmectacao) {
      nutritionPoints += 2;
    }

    if (profile.usesAcidificante) {
      hydrationPoints += 1;
    }

    hydrationPoints = hydrationPoints < 1 ? 1 : hydrationPoints;
    nutritionPoints = nutritionPoints < 1 ? 1 : nutritionPoints;
    reconstructionPoints = reconstructionPoints < 1 ? 1 : reconstructionPoints;

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
    final uuid = const Uuid();
    final initialEvents = <ScheduleEvent>[];

    int hydrationFrequency;
    if (scores['hydration']! > 8) {
      hydrationFrequency = 2;
    } else if (scores['hydration']! > 5) {
      hydrationFrequency = 3;
    } else if (scores['hydration']! > 3) {
      hydrationFrequency = 5;
    } else {
      hydrationFrequency = 7;
    }

    int nutritionFrequency;
    if (scores['nutrition']! > 7) {
      nutritionFrequency = 5;
    } else if (scores['nutrition']! > 4) {
      nutritionFrequency = 7;
    } else {
      nutritionFrequency = 14;
    }

    int reconstructionFrequency;
    if (scores['reconstruction']! > 8) {
      reconstructionFrequency = 7;
    } else if (scores['reconstruction']! > 5) {
      reconstructionFrequency = 14;
    } else if (scores['reconstruction']! > 3) {
      reconstructionFrequency = 21;
    } else {
      reconstructionFrequency = 28;
    }

    TreatmentIntensity hydrationIntensity;
    if (scores['hydration']! > 7) {
      hydrationIntensity = TreatmentIntensity.intensive;
    } else if (scores['hydration']! > 4) {
      hydrationIntensity = TreatmentIntensity.moderate;
    } else {
      hydrationIntensity = TreatmentIntensity.light;
    }

    TreatmentIntensity nutritionIntensity;
    if (scores['nutrition']! > 7) {
      nutritionIntensity = TreatmentIntensity.intensive;
    } else if (scores['nutrition']! > 4) {
      nutritionIntensity = TreatmentIntensity.moderate;
    } else {
      nutritionIntensity = TreatmentIntensity.light;
    }

    TreatmentIntensity reconstructionIntensity;
    if (scores['reconstruction']! > 7) {
      reconstructionIntensity = TreatmentIntensity.intensive;
    } else if (scores['reconstruction']! > 4) {
      reconstructionIntensity = TreatmentIntensity.moderate;
    } else {
      reconstructionIntensity = TreatmentIntensity.light;
    }

    List<Treatment> hydrationTreatments = availableTreatments
        .where((t) => t.type == TreatmentType.hydration && t.intensity == hydrationIntensity)
        .toList();

    List<Treatment> nutritionTreatments = availableTreatments
        .where((t) => t.type == TreatmentType.nutrition && t.intensity == nutritionIntensity)
        .toList();

    List<Treatment> reconstructionTreatments = availableTreatments
        .where((t) => t.type == TreatmentType.reconstruction && t.intensity == reconstructionIntensity)
        .toList();

    if (hydrationTreatments.isEmpty) {
      hydrationTreatments = availableTreatments.where((t) => t.type == TreatmentType.hydration).toList();
    }

    if (nutritionTreatments.isEmpty) {
      nutritionTreatments = availableTreatments.where((t) => t.type == TreatmentType.nutrition).toList();
    }

    if (reconstructionTreatments.isEmpty) {
      reconstructionTreatments = availableTreatments.where((t) => t.type == TreatmentType.reconstruction).toList();
    }

    if (hydrationTreatments.isNotEmpty) {
      for (int day = 0; day < durationInWeeks * 7; day += hydrationFrequency) {
        final currentDate = startDate.add(Duration(days: day));
        initialEvents.add(ScheduleEvent(
          id: uuid.v4(),
          treatmentId: hydrationTreatments.first.id,
          date: currentDate,
        ));
      }
    }

    if (nutritionTreatments.isNotEmpty) {
      for (int day = 3; day < durationInWeeks * 7; day += nutritionFrequency) {
        final currentDate = startDate.add(Duration(days: day));
        initialEvents.add(ScheduleEvent(
          id: uuid.v4(),
          treatmentId: nutritionTreatments.first.id,
          date: currentDate,
        ));
      }
    }

    if (reconstructionTreatments.isNotEmpty) {
      for (int day = 6; day < durationInWeeks * 7; day += reconstructionFrequency) {
        final currentDate = startDate.add(Duration(days: day));
        initialEvents.add(ScheduleEvent(
          id: uuid.v4(),
          treatmentId: reconstructionTreatments.first.id,
          date: currentDate,
        ));
      }
    }

    if (profile.wantsUmectacao) {
      final umectacaoTreatments = availableTreatments
          .where((t) => t.id == 'umectacao')
          .toList();

      if (umectacaoTreatments.isNotEmpty) {
        for (int day = 4; day < durationInWeeks * 7; day += 7) {
          final currentDate = startDate.add(Duration(days: day));
          initialEvents.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: umectacaoTreatments.first.id,
            date: currentDate,
          ));
        }
      }
    }

    if (profile.wantsTonalizacao) {
      final tonalizacaoTreatments = availableTreatments
          .where((t) => t.id == 'tonalizacao')
          .toList();

      if (tonalizacaoTreatments.isNotEmpty) {
        for (int day = 15; day < durationInWeeks * 7; day += 15) {
          final currentDate = startDate.add(Duration(days: day));
          initialEvents.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: tonalizacaoTreatments.first.id,
            date: currentDate,
          ));
        }
      }
    }

    if (profile.usesAcidificante) {
      final acidificanteTreatments = availableTreatments
          .where((t) => t.id == 'acidificante')
          .toList();

      if (acidificanteTreatments.isNotEmpty) {
        final reconstructionEventsDates = initialEvents
            .where((e) {
          final treatment = availableTreatments.firstWhere(
                (t) => t.id == e.treatmentId,
            orElse: () => Treatment(
              id: '',
              name: '',
              type: TreatmentType.special,
              intensity: TreatmentIntensity.light,
              description: '',
              durationMinutes: 0,
              recommendedFrequencyDays: 0,
            ),
          );
          return treatment.type == TreatmentType.reconstruction;
        })
            .map((e) => e.date.add(const Duration(days: 1)))
            .toList();

        for (var date in reconstructionEventsDates) {
          initialEvents.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: acidificanteTreatments.first.id,
            date: date,
          ));
        }
      }
    }

    if (profile.damage == HairDamage.severe) {
      if (hydrationTreatments.isNotEmpty) {
        for (int day = 10; day < durationInWeeks * 7; day += 14) {
          final currentDate = startDate.add(Duration(days: day));
          initialEvents.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: hydrationTreatments.first.id,
            date: currentDate,
          ));
        }
      }
    }

    if (profile.washFrequencyPerWeek > 5) {
      final detoxTreatments = availableTreatments
          .where((t) => t.type == TreatmentType.detox)
          .toList();

      if (detoxTreatments.isNotEmpty) {
        for (int day = 21; day < durationInWeeks * 7; day += 21) {
          final currentDate = startDate.add(Duration(days: day));
          initialEvents.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: detoxTreatments.first.id,
            date: currentDate,
          ));
        }
      }
    }

    if (profile.damage == HairDamage.severe && profile.usesHeatStyling) {
      final protecaoTreatments = availableTreatments
          .where((t) => t.id == 'protecao_solar')
          .toList();

      if (protecaoTreatments.isNotEmpty) {
        for (int day = 0; day < durationInWeeks * 7; day += 3) {
          final currentDate = startDate.add(Duration(days: day));
          initialEvents.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: protecaoTreatments.first.id,
            date: currentDate,
          ));
        }
      }
    }

    if (profile.curvature == HairCurvature.coily && profile.porosity == HairPorosity.low) {
      final nutritionIntTreatments = availableTreatments
          .where((t) => t.type == TreatmentType.nutrition && t.intensity == TreatmentIntensity.intensive)
          .toList();

      if (nutritionIntTreatments.isNotEmpty && nutritionIntTreatments.isNotEmpty) {
        for (int day = 10; day < durationInWeeks * 7; day += 10) {
          final currentDate = startDate.add(Duration(days: day));
          initialEvents.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: nutritionIntTreatments.first.id,
            date: currentDate,
          ));
        }
      }
    }

    final haircutTreatments = availableTreatments
        .where((t) => t.type == TreatmentType.haircut)
        .toList();

    if (haircutTreatments.isNotEmpty) {
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

      final daysSinceLastCut = startDate.difference(profile.lastCutDate).inDays;
      final daysUntilNextCut = haircutFrequency - daysSinceLastCut;

      if (daysUntilNextCut > 0 && daysUntilNextCut < durationInWeeks * 7) {
        final nextCutDate = startDate.add(Duration(days: daysUntilNextCut));
        initialEvents.add(ScheduleEvent(
          id: uuid.v4(),
          treatmentId: haircutTreatments.first.id,
          date: nextCutDate,
        ));
      }
    }

    final Map<DateTime, List<ScheduleEvent>> tempEventsByDate = {};

    for (var event in initialEvents) {
      final normalizedDate = DateTime(
        event.date.year,
        event.date.month,
        event.date.day,
      );

      if (!tempEventsByDate.containsKey(normalizedDate)) {
        tempEventsByDate[normalizedDate] = [];
      }
      tempEventsByDate[normalizedDate]!.add(event);
    }

    final finalEvents = <ScheduleEvent>[];
    final List<DateTime> scheduledDates = tempEventsByDate.keys.toList()..sort();

    for (var date in scheduledDates) {
      var eventsForDate = tempEventsByDate[date]!;

      if (eventsForDate.length <= 2) {
        finalEvents.addAll(eventsForDate);
      } else {
        finalEvents.addAll(eventsForDate.sublist(0, 2));

        var remainingEvents = eventsForDate.sublist(2);

        for (var event in remainingEvents) {
          var newDate = date;
          var foundSlot = false;

          for (int i = 1; i <= 7 && !foundSlot; i++) {
            newDate = date.add(Duration(days: i));

            if (!tempEventsByDate.containsKey(newDate) ||
                tempEventsByDate[newDate]!.length < 2) {
              var adjustedEvent = ScheduleEvent(
                id: uuid.v4(),
                treatmentId: event.treatmentId,
                date: newDate,
              );

              finalEvents.add(adjustedEvent);

              if (!tempEventsByDate.containsKey(newDate)) {
                tempEventsByDate[newDate] = [];
              }
              tempEventsByDate[newDate]!.add(adjustedEvent);

              foundSlot = true;
            }
          }

          if (!foundSlot) {
            var adjustedEvent = ScheduleEvent(
              id: uuid.v4(),
              treatmentId: event.treatmentId,
              date: date.add(Duration(days: 8)),
            );

            finalEvents.add(adjustedEvent);
          }
        }
      }
    }

    finalEvents.sort((a, b) => a.date.compareTo(b.date));

    return finalEvents;
  }

  void _diagnoseSchedulePersonalization(HairProfile profile, List<ScheduleEvent> events, Map<String, int> scores) {
    print('===== DIAGNÓSTICO DE PERSONALIZAÇÃO DO CRONOGRAMA =====');
    print('Perfil: Curvatura ${profile.curvature}, Porosidade ${profile.porosity}, Danos ${profile.damage}');
    print('Scores: Hidratação ${scores['hydration']}, Nutrição ${scores['nutrition']}, Reconstrução ${scores['reconstruction']}');

    int hydrationCount = 0;
    int nutritionCount = 0;
    int reconstructionCount = 0;

    for (var event in events) {
      final treatment = availableTreatments.firstWhere(
            (t) => t.id == event.treatmentId,
        orElse: () => Treatment(
          id: '',
          name: '',
          type: TreatmentType.special,
          intensity: TreatmentIntensity.light,
          description: '',
          durationMinutes: 0,
          recommendedFrequencyDays: 0,
        ),
      );

      if (treatment.type == TreatmentType.hydration) hydrationCount++;
      if (treatment.type == TreatmentType.nutrition) nutritionCount++;
      if (treatment.type == TreatmentType.reconstruction) reconstructionCount++;
    }

    print('Total de eventos: ${events.length}');
    print('Hidratação: $hydrationCount eventos (${(hydrationCount / events.length * 100).toStringAsFixed(1)}%)');
    print('Nutrição: $nutritionCount eventos (${(nutritionCount / events.length * 100).toStringAsFixed(1)}%)');
    print('Reconstrução: $reconstructionCount eventos (${(reconstructionCount / events.length * 100).toStringAsFixed(1)}%)');

    double hydrationRatio = hydrationCount / events.length;
    double nutritionRatio = nutritionCount / events.length;
    double reconstructionRatio = reconstructionCount / events.length;

    double expectedHydrationRatio = scores['hydration']! / (scores['hydration']! + scores['nutrition']! + scores['reconstruction']!);
    double expectedNutritionRatio = scores['nutrition']! / (scores['hydration']! + scores['nutrition']! + scores['reconstruction']!);
    double expectedReconstructionRatio = scores['reconstruction']! / (scores['hydration']! + scores['nutrition']! + scores['reconstruction']!);

    print('Proporção esperada: ${(expectedHydrationRatio * 100).toStringAsFixed(1)}% Hidratação, ${(expectedNutritionRatio * 100).toStringAsFixed(1)}% Nutrição, ${(expectedReconstructionRatio * 100).toStringAsFixed(1)}% Reconstrução');
    print('Proporção real: ${(hydrationRatio * 100).toStringAsFixed(1)}% Hidratação, ${(nutritionRatio * 100).toStringAsFixed(1)}% Nutrição, ${(reconstructionRatio * 100).toStringAsFixed(1)}% Reconstrução');

    bool isPersonalized =
        (hydrationRatio - expectedHydrationRatio).abs() < 0.1 &&
            (nutritionRatio - expectedNutritionRatio).abs() < 0.1 &&
            (reconstructionRatio - expectedReconstructionRatio).abs() < 0.1;

    print('Cronograma personalizado: ${isPersonalized ? "SIM" : "NÃO"}');
    print('=====================================================');
  }
}