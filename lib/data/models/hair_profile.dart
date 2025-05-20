import 'package:hive/hive.dart';

part 'hair_profile.g.dart';

@HiveType(typeId: 0)
enum HairCurvature {
  @HiveField(0)
  straight,
  @HiveField(1)
  wavy,
  @HiveField(2)
  curly,
  @HiveField(3)
  coily
}

@HiveType(typeId: 1)
enum HairLength {
  @HiveField(0)
  short,
  @HiveField(1)
  medium,
  @HiveField(2)
  long
}

@HiveType(typeId: 2)
enum HairThickness {
  @HiveField(0)
  fine,
  @HiveField(1)
  medium,
  @HiveField(2)
  thick
}

@HiveType(typeId: 3)
enum HairOiliness {
  @HiveField(0)
  dry,
  @HiveField(1)
  normal,
  @HiveField(2)
  oily
}

@HiveType(typeId: 4)
enum HairDamage {
  @HiveField(0)
  none,
  @HiveField(1)
  light,
  @HiveField(2)
  moderate,
  @HiveField(3)
  severe
}

@HiveType(typeId: 5)
enum HairElasticity {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high
}

@HiveType(typeId: 6)
enum HairPorosity {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high
}

@HiveType(typeId: 7)
class HairProfile extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  HairCurvature curvature;

  @HiveField(2)
  HairLength length;

  @HiveField(3)
  HairThickness thickness;

  @HiveField(4)
  HairOiliness oiliness;

  @HiveField(5)
  HairDamage damage;

  @HiveField(6)
  bool usesHeatStyling;

  @HiveField(7)
  HairElasticity elasticity;

  @HiveField(8)
  HairPorosity porosity;

  @HiveField(9)
  int washFrequencyPerWeek;

  @HiveField(10)
  DateTime lastCutDate;

  @HiveField(11)
  DateTime? lastChemicalTreatmentDate;

  @HiveField(12)
  String? chemicalTreatmentType;

  HairProfile({
    required this.id,
    required this.curvature,
    required this.length,
    required this.thickness,
    required this.oiliness,
    required this.damage,
    required this.usesHeatStyling,
    required this.elasticity,
    required this.porosity,
    required this.washFrequencyPerWeek,
    required this.lastCutDate,
    this.lastChemicalTreatmentDate,
    this.chemicalTreatmentType,
  });

  HairProfile copyWith({
    String? id,
    HairCurvature? curvature,
    HairLength? length,
    HairThickness? thickness,
    HairOiliness? oiliness,
    HairDamage? damage,
    bool? usesHeatStyling,
    HairElasticity? elasticity,
    HairPorosity? porosity,
    int? washFrequencyPerWeek,
    DateTime? lastCutDate,
    DateTime? lastChemicalTreatmentDate,
    String? chemicalTreatmentType,
  }) {
    return HairProfile(
      id: id ?? this.id,
      curvature: curvature ?? this.curvature,
      length: length ?? this.length,
      thickness: thickness ?? this.thickness,
      oiliness: oiliness ?? this.oiliness,
      damage: damage ?? this.damage,
      usesHeatStyling: usesHeatStyling ?? this.usesHeatStyling,
      elasticity: elasticity ?? this.elasticity,
      porosity: porosity ?? this.porosity,
      washFrequencyPerWeek: washFrequencyPerWeek ?? this.washFrequencyPerWeek,
      lastCutDate: lastCutDate ?? this.lastCutDate,
      lastChemicalTreatmentDate: lastChemicalTreatmentDate ?? this.lastChemicalTreatmentDate,
      chemicalTreatmentType: chemicalTreatmentType ?? this.chemicalTreatmentType,
    );
  }
}