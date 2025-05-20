import 'package:flutter/foundation.dart';

enum HairCurvature { straight, wavy, curly, coily }
enum HairLength { short, medium, long }
enum HairThickness { fine, medium, thick }
enum HairOiliness { dry, normal, oily }
enum HairDamage { none, light, moderate, severe }
enum HairElasticity { low, medium, high }
enum HairPorosity { low, medium, high }

class HairProfile {
  final String id;
  final HairCurvature curvature;
  final HairLength length;
  final HairThickness thickness;
  final HairOiliness oiliness;
  final HairDamage damage;
  final bool usesHeatStyling;
  final HairElasticity elasticity;
  final HairPorosity porosity;
  final int washFrequencyPerWeek;
  final DateTime lastCutDate;
  final DateTime? lastChemicalTreatmentDate;
  final String? chemicalTreatmentType;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'curvature': curvature.index,
      'length': length.index,
      'thickness': thickness.index,
      'oiliness': oiliness.index,
      'damage': damage.index,
      'usesHeatStyling': usesHeatStyling,
      'elasticity': elasticity.index,
      'porosity': porosity.index,
      'washFrequencyPerWeek': washFrequencyPerWeek,
      'lastCutDate': lastCutDate.toIso8601String(),
      'lastChemicalTreatmentDate': lastChemicalTreatmentDate?.toIso8601String(),
      'chemicalTreatmentType': chemicalTreatmentType,
    };
  }

  factory HairProfile.fromJson(Map<String, dynamic> json) {
    return HairProfile(
      id: json['id'],
      curvature: HairCurvature.values[json['curvature']],
      length: HairLength.values[json['length']],
      thickness: HairThickness.values[json['thickness']],
      oiliness: HairOiliness.values[json['oiliness']],
      damage: HairDamage.values[json['damage']],
      usesHeatStyling: json['usesHeatStyling'],
      elasticity: HairElasticity.values[json['elasticity']],
      porosity: HairPorosity.values[json['porosity']],
      washFrequencyPerWeek: json['washFrequencyPerWeek'],
      lastCutDate: DateTime.parse(json['lastCutDate']),
      lastChemicalTreatmentDate: json['lastChemicalTreatmentDate'] != null
          ? DateTime.parse(json['lastChemicalTreatmentDate'])
          : null,
      chemicalTreatmentType: json['chemicalTreatmentType'],
    );
  }
}