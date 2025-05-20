import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/hair_profile.dart';
import '../../models/schedule.dart';
import '../../models/treatment.dart';

class HiveDataSource {
  static const String hairProfileBoxName = 'hair_profiles';
  static const String scheduleBoxName = 'schedules';
  static const String treatmentBoxName = 'treatments';

  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    Hive.registerAdapter(HairProfileAdapter());
    Hive.registerAdapter(HairCurvatureAdapter());
    Hive.registerAdapter(HairLengthAdapter());
    Hive.registerAdapter(HairThicknessAdapter());
    Hive.registerAdapter(HairOilinessAdapter());
    Hive.registerAdapter(HairDamageAdapter());
    Hive.registerAdapter(HairElasticityAdapter());
    Hive.registerAdapter(HairPorosityAdapter());

    Hive.registerAdapter(ScheduleAdapter());
    Hive.registerAdapter(ScheduleEventAdapter());

    Hive.registerAdapter(TreatmentAdapter());
    Hive.registerAdapter(TreatmentTypeAdapter());
    Hive.registerAdapter(TreatmentIntensityAdapter());

    await Hive.openBox<HairProfile>(hairProfileBoxName);
    await Hive.openBox<Schedule>(scheduleBoxName);
    await Hive.openBox<Treatment>(treatmentBoxName);
  }

  static Box<HairProfile> getHairProfileBox() {
    return Hive.box<HairProfile>(hairProfileBoxName);
  }

  static Box<Schedule> getScheduleBox() {
    return Hive.box<Schedule>(scheduleBoxName);
  }

  static Box<Treatment> getTreatmentBox() {
    return Hive.box<Treatment>(treatmentBoxName);
  }

  static Future<void> initializeDefaultTreatments() async {
    final treatmentBox = getTreatmentBox();

    if (treatmentBox.isEmpty) {
      final defaultTreatments = _getDefaultTreatments();
      for (var treatment in defaultTreatments) {
        await treatmentBox.put(treatment.id, treatment);
      }
    }
  }

  static List<Treatment> _getDefaultTreatments() {
    return [
      Treatment(
        id: 'hydration_light',
        name: 'Hidratação Suave',
        type: TreatmentType.hydration,
        intensity: TreatmentIntensity.light,
        description: 'Hidratação leve para manutenção diária.',
        durationMinutes: 20,
        recommendedFrequencyDays: 7,
        productRecommendations: 'Máscaras de hidratação sem óleo.',
      ),
      Treatment(
        id: 'hydration_intensive',
        name: 'Hidratação Profunda',
        type: TreatmentType.hydration,
        intensity: TreatmentIntensity.intensive,
        description: 'Hidratação intensa para cabelos muito ressecados.',
        durationMinutes: 40,
        recommendedFrequencyDays: 14,
        productRecommendations: 'Máscaras de hidratação profunda, óleos vegetais.',
      ),
      Treatment(
        id: 'nutrition_light',
        name: 'Nutrição Leve',
        type: TreatmentType.nutrition,
        intensity: TreatmentIntensity.light,
        description: 'Nutrição leve para manutenção semanal.',
        durationMinutes: 30,
        recommendedFrequencyDays: 7,
        productRecommendations: 'Máscaras nutritivas com óleos vegetais leves.',
      ),
      Treatment(
        id: 'nutrition_intensive',
        name: 'Nutrição Intensiva',
        type: TreatmentType.nutrition,
        intensity: TreatmentIntensity.intensive,
        description: 'Nutrição profunda para cabelos danificados.',
        durationMinutes: 40,
        recommendedFrequencyDays: 14,
        productRecommendations: 'Máscaras com manteiga de karité, abacate ou coco.',
      ),
      Treatment(
        id: 'reconstruction_light',
        name: 'Reconstrução Leve',
        type: TreatmentType.reconstruction,
        intensity: TreatmentIntensity.light,
        description: 'Reconstrução leve para manutenção regular.',
        durationMinutes: 30,
        recommendedFrequencyDays: 14,
        productRecommendations: 'Produtos com queratina hidrolisada ou proteínas do trigo.',
      ),
      Treatment(
        id: 'reconstruction_moderate',
        name: 'Reconstrução Moderada',
        type: TreatmentType.reconstruction,
        intensity: TreatmentIntensity.moderate,
        description: 'Reconstrução média para cabelos moderadamente danificados.',
        durationMinutes: 40,
        recommendedFrequencyDays: 21,
        productRecommendations: 'Produtos com queratina e proteínas vegetais.',
      ),
      Treatment(
        id: 'reconstruction_intensive',
        name: 'Reconstrução Intensiva',
        type: TreatmentType.reconstruction,
        intensity: TreatmentIntensity.intensive,
        description: 'Reconstrução profunda para cabelos muito danificados.',
        durationMinutes: 60,
        recommendedFrequencyDays: 30,
        productRecommendations: 'Produtos com alta concentração de proteínas e aminoácidos.',
      ),
      Treatment(
        id: 'detox',
        name: 'Detox Capilar',
        type: TreatmentType.detox,
        intensity: TreatmentIntensity.moderate,
        description: 'Limpeza profunda para remover resíduos.',
        durationMinutes: 30,
        recommendedFrequencyDays: 30,
        productRecommendations: 'Shampoo anti-resíduos, argila verde ou vinagre de maçã.',
      ),
      Treatment(
        id: 'haircut',
        name: 'Corte de Pontas',
        type: TreatmentType.haircut,
        intensity: TreatmentIntensity.light,
        description: 'Corte regular para manutenção das pontas.',
        durationMinutes: 60,
        recommendedFrequencyDays: 90,
        productRecommendations: 'Procure um profissional qualificado.',
      ),
      Treatment(
        id: 'exfoliation',
        name: 'Esfoliação do Couro Cabeludo',
        type: TreatmentType.exfoliation,
        intensity: TreatmentIntensity.moderate,
        description: 'Remover células mortas e estimular o couro cabeludo.',
        durationMinutes: 20,
        recommendedFrequencyDays: 30,
        productRecommendations: 'Esfoliantes específicos para couro cabeludo.',
      ),
    ];
  }
}