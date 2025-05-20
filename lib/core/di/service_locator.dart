import 'package:get_it/get_it.dart';

import '../../data/data_sources/local/hive_data_source.dart';
import '../../data/repositories/hair_profile_repository.dart';
import '../../data/repositories/schedule_repository.dart';
import '../../data/repositories/treatment_repository.dart';
import '../../domain/repositories/hair_profile_repository.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../../domain/repositories/treatment_repository.dart';
import '../../presentation/mvvm_pages/hair_profile/providers/hair_profile_provider.dart';
import '../../presentation/mvvm_pages/home/providers/home_provider.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  await HiveDataSource.init();

  await HiveDataSource.initializeDefaultTreatments();

  // Repositories
  getIt.registerLazySingleton<HairProfileRepository>(
        () => HairProfileRepositoryImpl(),
  );

  getIt.registerLazySingleton<ScheduleRepository>(
        () => ScheduleRepositoryImpl(),
  );

  getIt.registerLazySingleton<TreatmentRepository>(
        () => TreatmentRepositoryImpl(),
  );

  // Providers
  getIt.registerFactory<HairProfileProvider>(
        () => HairProfileProvider(getIt<HairProfileRepository>()),
  );

  getIt.registerFactory<HomeProvider>(
        () => HomeProvider(
      profileRepository: getIt<HairProfileRepository>(),
      scheduleRepository: getIt<ScheduleRepository>(),
      treatmentRepository: getIt<TreatmentRepository>(),
    ),
  );
}