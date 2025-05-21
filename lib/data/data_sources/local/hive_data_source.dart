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
        id: 'hydration',
        name: 'Hidratação',
        type: TreatmentType.hydration,
        intensity: TreatmentIntensity.moderate,
        description: 'Tratamento para repor a umidade dos fios.',
        durationMinutes: 30,
        recommendedFrequencyDays: 7,
        productRecommendations: 'Máscaras de hidratação.',
      ),
      Treatment(
        id: 'nutrition',
        name: 'Nutrição',
        type: TreatmentType.nutrition,
        intensity: TreatmentIntensity.moderate,
        description: 'Tratamento para repor lipídios e nutrientes.',
        durationMinutes: 30,
        recommendedFrequencyDays: 7,
        productRecommendations: 'Máscaras nutritivas com óleos vegetais.',
      ),
      Treatment(
        id: 'reconstruction',
        name: 'Reconstrução',
        type: TreatmentType.reconstruction,
        intensity: TreatmentIntensity.moderate,
        description: 'Tratamento para repor proteínas e fortalecer os fios.',
        durationMinutes: 40,
        recommendedFrequencyDays: 14,
        productRecommendations: 'Produtos com queratina e proteínas vegetais.',
      ),

      Treatment(
        id: 'detox',
        name: 'Detox',
        type: TreatmentType.detox,
        intensity: TreatmentIntensity.moderate,
        description: 'Limpeza profunda para remover resíduos.',
        durationMinutes: 30,
        recommendedFrequencyDays: 30,
        productRecommendations: 'Shampoo anti-resíduos ou argila.',
      ),
      Treatment(
        id: 'exfoliation',
        name: 'Esfoliação',
        type: TreatmentType.exfoliation,
        intensity: TreatmentIntensity.moderate,
        description: 'Remover células mortas e estimular o couro cabeludo.',
        durationMinutes: 20,
        recommendedFrequencyDays: 30,
        productRecommendations: 'Esfoliantes específicos para couro cabeludo.',
      ),
      Treatment(
        id: 'clay_mask',
        name: 'Máscara de Argila',
        type: TreatmentType.detox,
        intensity: TreatmentIntensity.moderate,
        description: 'Limpeza com argila para remover impurezas.',
        durationMinutes: 30,
        recommendedFrequencyDays: 15,
        productRecommendations: 'Argila verde, branca ou preta.',
      ),

      Treatment(
        id: 'haircut',
        name: 'Corte',
        type: TreatmentType.haircut,
        intensity: TreatmentIntensity.light,
        description: 'Manutenção das pontas.',
        durationMinutes: 60,
        recommendedFrequencyDays: 90,
        productRecommendations: '',
      ),

      Treatment(
        id: 'umectacao',
        name: 'Umectação',
        type: TreatmentType.oilTreatment,
        intensity: TreatmentIntensity.moderate,
        description: 'Aplicação de óleos capilares para nutrição.',
        durationMinutes: 480,
        recommendedFrequencyDays: 7,
        productRecommendations: 'Óleo de coco, azeite de oliva, óleo de argan.',
      ),

      Treatment(
        id: 'tonalizacao',
        name: 'Tonalização',
        type: TreatmentType.colorTouch,
        intensity: TreatmentIntensity.moderate,
        description: 'Tratamento com pigmentos para manter ou corrigir a cor.',
        durationMinutes: 30,
        recommendedFrequencyDays: 15,
        productRecommendations: 'Máscara matizadora ou shampoo matizador.',
      ),
      Treatment(
        id: 'retoque_cor',
        name: 'Retoque de Tintura',
        type: TreatmentType.colorTouch,
        intensity: TreatmentIntensity.intensive,
        description: 'Retoque da coloração na raiz.',
        durationMinutes: 120,
        recommendedFrequencyDays: 42,
        productRecommendations: 'Coloração similar à usada anteriormente.',
      ),
      Treatment(
        id: 'retoque_luzes',
        name: 'Retoque de Mechas',
        type: TreatmentType.colorTouch,
        intensity: TreatmentIntensity.intensive,
        description: 'Retoque de mechas ou luzes.',
        durationMinutes: 180,
        recommendedFrequencyDays: 90,
        productRecommendations: 'Recomendado fazer com profissional.',
      ),

      Treatment(
        id: 'acidificante',
        name: 'Acidificante',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.light,
        description: 'Equilibrar o pH do cabelo.',
        durationMinutes: 15,
        recommendedFrequencyDays: 15,
        productRecommendations: 'Vinagre de maçã diluído ou produtos específicos.',
      ),
      Treatment(
        id: 'retoque_alisamento',
        name: 'Retoque de Alisamento',
        type: TreatmentType.chemicalTreatment,
        intensity: TreatmentIntensity.intensive,
        description: 'Retoque de progressiva ou alisamento na raiz.',
        durationMinutes: 180,
        recommendedFrequencyDays: 120,
        productRecommendations: 'Recomendado fazer com profissional.',
      ),

      Treatment(
        id: 'manutencao_megahair',
        name: 'Manutenção de Megahair',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.moderate,
        description: 'Ajuste e manutenção das extensões capilares.',
        durationMinutes: 120,
        recommendedFrequencyDays: 40,
        productRecommendations: 'Recomendado fazer com profissional.',
      ),
      Treatment(
        id: 'manutencao_trancas',
        name: 'Manutenção de Tranças',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.moderate,
        description: 'Ajuste e manutenção das tranças ou box braids.',
        durationMinutes: 180,
        recommendedFrequencyDays: 42,
        productRecommendations: 'Recomendado fazer com profissional.',
      ),
      Treatment(
        id: 'manutencao_dreads',
        name: 'Manutenção de Dreads',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.moderate,
        description: 'Ajuste e manutenção dos dreads.',
        durationMinutes: 120,
        recommendedFrequencyDays: 35,
        productRecommendations: 'Recomendado fazer com profissional.',
      ),

      Treatment(
        id: 'tratamento_antiqueda',
        name: 'Tratamento Anti-queda',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.intensive,
        description: 'Tratamento para combater a queda de cabelo.',
        durationMinutes: 40,
        recommendedFrequencyDays: 7,
        productRecommendations: 'Tônicos capilares ou ampolas específicas.',
      ),
      Treatment(
        id: 'tratamento_caspa',
        name: 'Tratamento para Caspa',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.moderate,
        description: 'Tratamento para controlar a caspa.',
        durationMinutes: 20,
        recommendedFrequencyDays: 3,
        productRecommendations: 'Shampoo anticaspa específico.',
      ),

      Treatment(
        id: 'limpeza_ferramentas',
        name: 'Limpeza de Escovas',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.light,
        description: 'Limpeza e higienização de escovas e pentes.',
        durationMinutes: 20,
        recommendedFrequencyDays: 7,
        productRecommendations: 'Água morna com shampoo neutro.',
      ),
      Treatment(
        id: 'troca_fronha',
        name: 'Troca de Fronha',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.light,
        description: 'Troca de fronha para manter a higiene capilar.',
        durationMinutes: 5,
        recommendedFrequencyDays: 3,
        productRecommendations: 'Preferência por fronhas de cetim ou seda.',
      ),

      Treatment(
        id: 'foto_acompanhamento',
        name: 'Registro de Crescimento',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.light,
        description: 'Tirar fotos para acompanhar o crescimento e resultados.',
        durationMinutes: 5,
        recommendedFrequencyDays: 30,
        productRecommendations: 'Use condições similares de luz para comparação.',
      ),
      Treatment(
        id: 'protecao_solar',
        name: 'Proteção Solar',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.light,
        description: 'Aplicação de protetor solar para os fios.',
        durationMinutes: 2,
        recommendedFrequencyDays: 1,
        productRecommendations: 'Protetores solares específicos para cabelo.',
      ),
      Treatment(
        id: 'protecao_noturna',
        name: 'Proteção Noturna',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.light,
        description: 'Uso de touca ou fronha para proteger durante o sono.',
        durationMinutes: 1,
        recommendedFrequencyDays: 1,
        productRecommendations: 'Touca de cetim/seda ou fronha específica.',
      ),
    ];
  }
}