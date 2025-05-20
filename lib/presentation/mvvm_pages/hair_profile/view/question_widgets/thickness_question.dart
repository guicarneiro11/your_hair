import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/theme.dart';
import '../../../../../data/models/hair_profile.dart';
import '../../providers/hair_profile_provider.dart';

class ThicknessQuestion extends StatelessWidget {
  const ThicknessQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HairProfileProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Dica: Pegue um fio de cabelo e compare com um fio de linha de costura. Se for mais fino que a linha, é fino. Se for similar, é médio. Se for mais grosso, é grosso.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textMedium,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildThicknessOption(
            context,
            HairThickness.fine,
            'Fino',
            'Fios delicados, menos resistentes e que quebram com facilidade.',
            provider,
          ),
          _buildThicknessOption(
            context,
            HairThickness.medium,
            'Médio',
            'Fios com espessura média, nem muito finos nem muito grossos.',
            provider,
          ),
          _buildThicknessOption(
            context,
            HairThickness.thick,
            'Grosso',
            'Fios resistentes, com diâmetro maior e mais volume.',
            provider,
          ),
        ],
      ),
    );
  }

  Widget _buildThicknessOption(
      BuildContext context,
      HairThickness thickness,
      String title,
      String description,
      HairProfileProvider provider,
      ) {
    final isSelected = provider.thickness == thickness;

    return GestureDetector(
      onTap: () {
        provider.setThickness(thickness);
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
              child: Center(
                child: _buildThicknessIndicator(thickness),
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

  Widget _buildThicknessIndicator(HairThickness thickness) {
    double strokeWidth;

    switch (thickness) {
      case HairThickness.fine:
        strokeWidth = 1.0;
        break;
      case HairThickness.medium:
        strokeWidth = 3.0;
        break;
      case HairThickness.thick:
        strokeWidth = 5.0;
        break;
    }

    return Container(
      width: 30,
      height: strokeWidth,
      color: AppColors.primary,
    );
  }
}