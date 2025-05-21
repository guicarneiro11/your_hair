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
      Treatment(
        id: 'umectacao',
        name: 'Umectação Noturna',
        type: TreatmentType.oilTreatment,
        intensity: TreatmentIntensity.moderate,
        description: 'Aplicação de óleos capilares para dormir, protegendo os fios e aumentando a nutrição.',
        durationMinutes: 480, // Noite toda
        recommendedFrequencyDays: 7, // Semanal
        productRecommendations: 'Óleo de coco, azeite de oliva, óleo de argan.',
      ),
      Treatment(
        id: 'tonalizacao',
        name: 'Tonalização/Matização',
        type: TreatmentType.colorTouch,
        intensity: TreatmentIntensity.moderate,
        description: 'Tratamento com pigmentos para manter ou corrigir a cor dos cabelos.',
        durationMinutes: 30,
        recommendedFrequencyDays: 15, // A cada 15 dias
        productRecommendations: 'Máscara matizadora ou shampoo matizador.',
      ),
      Treatment(
        id: 'acidificante',
        name: 'Tratamento Acidificante',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.light,
        description: 'Tratamento para equilibrar o pH do cabelo e melhorar o fechamento das cutículas.',
        durationMinutes: 15,
        recommendedFrequencyDays: 15, // Quinzenal
        productRecommendations: 'Vinagre de maçã diluído ou produtos acidificantes específicos.',
      ),
      Treatment(
        id: 'mascara_argila',
        name: 'Máscara de Argila',
        type: TreatmentType.detox,
        intensity: TreatmentIntensity.moderate,
        description: 'Limpeza profunda do couro cabeludo e fios com argila.',
        durationMinutes: 30,
        recommendedFrequencyDays: 15, // Quinzenal
        productRecommendations: 'Argila verde, branca ou preta.',
      ),
      Treatment(
        id: 'retoque_cor',
        name: 'Retoque de Cor',
        type: TreatmentType.colorTouch,
        intensity: TreatmentIntensity.intensive,
        description: 'Retoque da coloração na raiz do cabelo.',
        durationMinutes: 120,
        recommendedFrequencyDays: 42, // A cada 6 semanas
        productRecommendations: 'Coloração igual à usada anteriormente.',
      ),
      Treatment(
        id: 'retoque_luzes',
        name: 'Retoque de Mechas/Luzes',
        type: TreatmentType.colorTouch,
        intensity: TreatmentIntensity.intensive,
        description: 'Retoque de mechas ou luzes que cresceram.',
        durationMinutes: 180,
        recommendedFrequencyDays: 90, // A cada 3 meses
        productRecommendations: 'Procure um profissional especializado.',
      ),
      Treatment(
        id: 'retoque_alisamento',
        name: 'Retoque de Alisamento',
        type: TreatmentType.chemicalTreatment,
        intensity: TreatmentIntensity.intensive,
        description: 'Retoque de progressiva ou alisamento na raiz.',
        durationMinutes: 180,
        recommendedFrequencyDays: 120, // A cada 4 meses
        productRecommendations: 'Procure um profissional especializado.',
      ),
      Treatment(
        id: 'manutencao_megahair',
        name: 'Manutenção de Megahair',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.moderate,
        description: 'Ajuste e manutenção das extensões capilares.',
        durationMinutes: 120,
        recommendedFrequencyDays: 40, // A cada 40 dias
        productRecommendations: 'Procure um profissional especializado.',
      ),
      Treatment(
        id: 'manutencao_trancas',
        name: 'Manutenção de Tranças',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.moderate,
        description: 'Ajuste e manutenção das tranças ou box braids.',
        durationMinutes: 180,
        recommendedFrequencyDays: 42, // A cada 6 semanas
        productRecommendations: 'Procure um profissional especializado.',
      ),
      Treatment(
        id: 'manutencao_dreads',
        name: 'Manutenção de Dreads',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.moderate,
        description: 'Ajuste e manutenção dos dreads.',
        durationMinutes: 120,
        recommendedFrequencyDays: 35, // A cada 5 semanas
        productRecommendations: 'Procure um profissional especializado.',
      ),
      Treatment(
        id: 'tratamento_antiqueda',
        name: 'Tratamento Anti-queda',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.intensive,
        description: 'Tratamento específico para combater a queda de cabelo.',
        durationMinutes: 40,
        recommendedFrequencyDays: 7, // Semanal
        productRecommendations: 'Tônicos capilares específicos ou ampolas anti-queda.',
      ),
      Treatment(
        id: 'tratamento_caspa',
        name: 'Tratamento para Caspa',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.moderate,
        description: 'Tratamento específico para controlar a caspa.',
        durationMinutes: 20,
        recommendedFrequencyDays: 3, // 2-3 vezes por semana
        productRecommendations: 'Shampoo anticaspa com zinco ou cetoconazol.',
      ),
      Treatment(
        id: 'limpeza_ferramentas',
        name: 'Limpeza de Escovas e Pentes',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.light,
        description: 'Limpeza e higienização de escovas e pentes para remover resíduos.',
        durationMinutes: 20,
        recommendedFrequencyDays: 7, // Semanal
        productRecommendations: 'Água morna com shampoo neutro.',
      ),
      Treatment(
        id: 'foto_acompanhamento',
        name: 'Registro de Crescimento',
        type: TreatmentType.special,
        intensity: TreatmentIntensity.light,
        description: 'Tirar fotos do cabelo para acompanhar o crescimento e resultados.',
        durationMinutes: 5,
        recommendedFrequencyDays: 30, // Mensal
        productRecommendations: 'Use uma câmera com boa resolução e tire fotos sempre nas mesmas condições de luz.',
      ),
    ];
  }
}