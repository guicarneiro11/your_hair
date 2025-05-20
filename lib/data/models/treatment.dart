import 'package:hive/hive.dart';

part 'treatment.g.dart';

@HiveType(typeId: 8)
enum TreatmentType {
  @HiveField(0)
  hydration,
  @HiveField(1)
  nutrition,
  @HiveField(2)
  reconstruction,
  @HiveField(3)
  detox,
  @HiveField(4)
  exfoliation,
  @HiveField(5)
  oilTreatment,
  @HiveField(6)
  haircut,
  @HiveField(7)
  colorTouch,
  @HiveField(8)
  hairMask,
  @HiveField(9)
  chemicalTreatment,
  @HiveField(10)
  special,
}

@HiveType(typeId: 9)
enum TreatmentIntensity {
  @HiveField(0)
  light,
  @HiveField(1)
  moderate,
  @HiveField(2)
  intensive,
}

@HiveType(typeId: 10)
class Treatment extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  TreatmentType type;

  @HiveField(3)
  TreatmentIntensity intensity;

  @HiveField(4)
  String description;

  @HiveField(5)
  int durationMinutes;

  @HiveField(6)
  int recommendedFrequencyDays;

  @HiveField(7)
  String? productRecommendations;

  Treatment({
    required this.id,
    required this.name,
    required this.type,
    required this.intensity,
    required this.description,
    required this.durationMinutes,
    required this.recommendedFrequencyDays,
    this.productRecommendations,
  });

  bool get isHydration => type == TreatmentType.hydration;
  bool get isNutrition => type == TreatmentType.nutrition;
  bool get isReconstruction => type == TreatmentType.reconstruction;

  Treatment copyWith({
    String? id,
    String? name,
    TreatmentType? type,
    TreatmentIntensity? intensity,
    String? description,
    int? durationMinutes,
    int? recommendedFrequencyDays,
    String? productRecommendations,
  }) {
    return Treatment(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      intensity: intensity ?? this.intensity,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      recommendedFrequencyDays: recommendedFrequencyDays ?? this.recommendedFrequencyDays,
      productRecommendations: productRecommendations ?? this.productRecommendations,
    );
  }
}