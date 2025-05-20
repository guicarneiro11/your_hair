import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/repositories/hair_profile_repository.dart';
import '../data/repositories/schedule_repository.dart';
import '../data/repositories/treatment_repository.dart';
import '../domain/repositories/hair_profile_repository.dart';
import '../domain/repositories/schedule_repository.dart';
import '../domain/repositories/treatment_repository.dart';
import '../presentation/mvvm_pages/onboarding/view/onboarding_page.dart';
import '../presentation/mvvm_pages/hair_profile/view/hair_profile_page.dart';
import '../presentation/mvvm_pages/hair_profile/providers/hair_profile_provider.dart';
import '../presentation/mvvm_pages/home/view/home_page.dart';
import '../presentation/mvvm_pages/home/providers/home_provider.dart';
import '../core/di/service_locator.dart';

class AppRoutes {
  static const String initial = '/';
  static const String onboarding = '/onboarding';
  static const String hairProfile = '/hair-profile';
  static const String home = '/home';
  static const String scheduleGenerator = '/schedule-generator';
  static const String scheduleView = '/schedule-view';
  static const String treatments = '/treatments';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingPage(),
        );
      case hairProfile:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<HairProfileProvider>(
            create: (context) => HairProfileProvider(
              Provider.of<HairProfileRepository>(context, listen: false),
            ),
            child: const HairProfilePage(),
          ),
        );
      case home:
        return MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<HomeProvider>(
            create: (context) => HomeProvider(
              profileRepository: Provider.of<HairProfileRepository>(context, listen: false),
              scheduleRepository: Provider.of<ScheduleRepository>(context, listen: false),
              treatmentRepository: Provider.of<TreatmentRepository>(context, listen: false),
            ),
            child: const HomePage(),
          ),
        );
    // Adicione outras rotas conforme for implementando as páginas
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}