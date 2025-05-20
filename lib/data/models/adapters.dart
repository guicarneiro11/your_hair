import 'package:hive/hive.dart';
import 'hair_profile.dart';
import 'treatment.dart';
import 'schedule.dart';

class HiveAdapters {
  static void registerAdapters() {
    Hive.registerAdapter(HairCurvatureAdapter());
    Hive.registerAdapter(HairLengthAdapter());
    Hive.registerAdapter(HairThicknessAdapter());
    Hive.registerAdapter(HairOilinessAdapter());
    Hive.registerAdapter(HairDamageAdapter());
    Hive.registerAdapter(HairElasticityAdapter());
    Hive.registerAdapter(HairPorosityAdapter());
    Hive.registerAdapter(HairProfileAdapter());

    Hive.registerAdapter(TreatmentTypeAdapter());
    Hive.registerAdapter(TreatmentIntensityAdapter());
    Hive.registerAdapter(TreatmentAdapter());

    Hive.registerAdapter(ScheduleEventAdapter());
    Hive.registerAdapter(ScheduleAdapter());
  }
}