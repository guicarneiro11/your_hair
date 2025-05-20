import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'core/di/service_locator.dart';
import 'domain/repositories/hair_profile_repository.dart';
import 'domain/repositories/schedule_repository.dart';
import 'domain/repositories/treatment_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        Provider<HairProfileRepository>(
          create: (_) => getIt<HairProfileRepository>(),
        ),
        Provider<ScheduleRepository>(
          create: (_) => getIt<ScheduleRepository>(),
        ),
        Provider<TreatmentRepository>(
          create: (_) => getIt<TreatmentRepository>(),
        ),
      ],
      child: const YourHairApp(),
    ),
  );
}