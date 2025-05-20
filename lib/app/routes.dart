import 'package:flutter/material.dart';
import '../presentation/mvvm_pages/onboarding/view/onboarding_page.dart';

class AppRoutes {
  static const String initial = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String hairProfile = '/hair-profile';
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