import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/theme.dart';
import '../../../../../data/models/hair_profile.dart';
import '../../providers/hair_profile_provider.dart';

class LengthQuestion extends StatelessWidget {
  const LengthQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HairProfileProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          _buildLengthOption(
            context,
            HairLength.short,
            'Curto',
            'Acima dos ombros (até 10cm).',
            'assets/images/short_hair.png',
            provider,
          ),
          _buildLengthOption(
            context,
            HairLength.medium,
            'Médio',
            'Na altura dos ombros ou um pouco abaixo (10-30cm).',
            'assets/images/medium_hair.png',
            provider,
          ),
          _buildLengthOption(
            context,
            HairLength.long,
            'Longo',
            'Abaixo dos ombros (mais de 30cm).',
            'assets/images/long_hair.png',
            provider,
          ),
        ],
      ),
    );
  }

  Widget _buildLengthOption(
      BuildContext context,
      HairLength length,
      String title,
      String description,
      String imagePath,
      HairProfileProvider provider,
      ) {
    final isSelected = provider.length == length;

    return GestureDetector(
      onTap: () {
        provider.setLength(length);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getLengthIcon(length),
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }

  IconData _getLengthIcon(HairLength length) {
    switch (length) {
      case HairLength.short:
        return Icons.content_cut;
      case HairLength.medium:
        return Icons.straighten;
      case HairLength.long:
        return Icons.height;
    }
  }
}