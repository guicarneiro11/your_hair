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

    if (profile.wantsUmectacao) {
      final umectacaoTreatments = availableTreatments
          .where((t) => t.id == 'umectacao')
          .toList();

      if (umectacaoTreatments.isNotEmpty) {
        final frequency = 7; // semanal

        for (int day = 7; day < durationInWeeks * 7; day += frequency) {
          final treatmentDate = startDate.add(Duration(days: day));
          events.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: umectacaoTreatments.first.id,
            date: treatmentDate,
          ));
        }
      }
    }

    // 2. Tonalização/Matização (a cada 15-20 dias)
    if (profile.wantsTonalizacao) {
      final tonalizacaoTreatments = availableTreatments
          .where((t) => t.id == 'tonalizacao')
          .toList();

      if (tonalizacaoTreatments.isNotEmpty) {
        final frequency = 15; // a cada 15 dias

        for (int day = 15; day < durationInWeeks * 7; day += frequency) {
          final treatmentDate = startDate.add(Duration(days: day));
          events.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: tonalizacaoTreatments.first.id,
            date: treatmentDate,
          ));
        }
      }
    }

    // 3. Acidificante (quinzenal, após reconstrução)
    if (profile.usesAcidificante) {
      final acidificanteTreatments = availableTreatments
          .where((t) => t.id == 'acidificante')
          .toList();

      if (acidificanteTreatments.isNotEmpty) {
        // Adicionar após cada tratamento de reconstrução
        for (var event in events.where((e) =>
        availableTreatments.firstWhere((t) => t.id == e.treatmentId).type == TreatmentType.reconstruction)) {

          events.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: acidificanteTreatments.first.id,
            date: event.date.add(const Duration(days: 1)), // Dia seguinte à reconstrução
          ));
        }
      }
    }

    // 4. Máscara de Argila (quinzenal)
    final argilaTreatments = availableTreatments
        .where((t) => t.id == 'mascara_argila')
        .toList();

    if (argilaTreatments.isNotEmpty) {
      final frequency = 15; // a cada 15 dias

      for (int day = 10; day < durationInWeeks * 7; day += frequency) {
        final treatmentDate = startDate.add(Duration(days: day));
        events.add(ScheduleEvent(
          id: uuid.v4(),
          treatmentId: argilaTreatments.first.id,
          date: treatmentDate,
        ));
      }
    }

    // 5. Retoque de Tintura (a cada 4-6 semanas)
    if (profile.wantsHairColorRetouching) {
      final retoqueTreatments = availableTreatments
          .where((t) => t.id == 'retoque_cor')
          .toList();

      if (retoqueTreatments.isNotEmpty) {
        // Verificar a data do último retoque
        final lastChemical = profile.lastChemicalTreatmentDate;
        if (lastChemical != null &&
            profile.chemicalTreatmentType != null &&
            profile.chemicalTreatmentType!.toLowerCase().contains('cor')) {

          final daysSinceLastTreatment = startDate.difference(lastChemical).inDays;
          int daysUntilNextTreatment = 42 - daysSinceLastTreatment; // 6 semanas

          if (daysUntilNextTreatment < 0) {
            daysUntilNextTreatment = 7; // Já está atrasado, programar para semana 1
          }

          if (daysUntilNextTreatment < durationInWeeks * 7) {
            final treatmentDate = startDate.add(Duration(days: daysUntilNextTreatment));
            events.add(ScheduleEvent(
              id: uuid.v4(),
              treatmentId: retoqueTreatments.first.id,
              date: treatmentDate,
            ));
          }
        } else {
          // Sem histórico, programar para metade do período
          final treatmentDate = startDate.add(Duration(days: durationInWeeks * 7 ~/ 2));
          events.add(ScheduleEvent(
            id: uuid.v4(),
            treatmentId: retoqueTreatments.first.id,
            date: treatmentDate,
          ));
        }
      }
    }

    events.sort((a, b) => a.date.compareTo(b.date));

    _adjustOverlappingEvents(events);
    return events;
  }

  void _adjustOverlappingEvents(List<ScheduleEvent> events) {
    // Agrupar eventos por data
    final eventsByDate = <DateTime, List<ScheduleEvent>>{};

    for (var event in events) {
      final dateKey = DateTime(
          event.date.year, event.date.month, event.date.day);

      if (!eventsByDate.containsKey(dateKey)) {
        eventsByDate[dateKey] = [];
      }

      eventsByDate[dateKey]!.add(event);
    }

    // Ajustar eventos sobrepostos (mais de 2 por dia)
    for (var date in eventsByDate.keys) {
      final dateEvents = eventsByDate[date]!;

      if (dateEvents.length > 2) {
        // Manter apenas os 2 primeiros eventos neste dia
        final eventsToReschedule = dateEvents.sublist(2);

        // Remover os eventos excedentes da lista original
        for (var event in eventsToReschedule) {
          events.remove(event);
        }

        // Reagendar para os dias seguintes
        int offset = 1;
        for (var event in eventsToReschedule) {
          event.date = date.add(Duration(days: offset));
          offset++;
          events.add(event);
        }
      }
    }

    // Ordenar novamente após os ajustes
    events.sort((a, b) => a.date.compareTo(b.date));
  }
}