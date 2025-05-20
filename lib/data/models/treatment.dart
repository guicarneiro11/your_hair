import 'package:flutter/foundation.dart';

enum TreatmentType {
  hydration,
  nutrition,
  reconstruction,
  detox,
  exfoliation,
  oilTreatment,
  haircut,
  colorTouch,
  hairMask,
  chemicalTreatment,
  special,
}

enum TreatmentIntensity {
  light,
  moderate,
  intensive,
}

class Treatment {
  final String id;
  final String name;
  final TreatmentType type;
  final TreatmentIntensity intensity;
  final String description;
  final int durationMinutes;
  final int recommendedFrequencyDays;
  final String? productRecommendations;

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'intensity': intensity.index,
      'description': description,
      'durationMinutes': durationMinutes,
      'recommendedFrequencyDays': recommendedFrequencyDays,
      'productRecommendations': productRecommendations,
    };
  }

  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'],
      name: json['name'],
      type: TreatmentType.values[json['type']],
      intensity: TreatmentIntensity.values[json['intensity']],
      description: json['description'],
      durationMinutes: json['durationMinutes'],
      recommendedFrequencyDays: json['recommendedFrequencyDays'],
      productRecommendations: json['productRecommendations'],
    );
  }
}