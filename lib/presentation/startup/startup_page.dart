import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/theme.dart';
import '../../domain/repositories/hair_profile_repository.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
    _checkUserProfile();
  }

  Future<void> _checkUserProfile() async {
    try {
      final profileRepository = Provider.of<HairProfileRepository>(context, listen: false);
      final profile = await profileRepository.getProfile();

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      if (profile != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.spa,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Your Hair',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Seu cronograma capilar personalizado',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}