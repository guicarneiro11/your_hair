import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/theme.dart';
import '../../../../../data/models/hair_profile.dart';
import '../../providers/hair_profile_provider.dart';

class CurvatureQuestion extends StatelessWidget {
  const CurvatureQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HairProfileProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          _buildCurvatureOption(
            context,
            HairCurvature.straight,
            'Liso',
            'Cabelo que não forma ondas ou cachos naturalmente.',
            provider,
          ),
          _buildCurvatureOption(
            context,
            HairCurvature.wavy,
            'Ondulado',
            'Cabelo com ondas suaves e padrão em "S".',
            provider,
          ),
          _buildCurvatureOption(
            context,
            HairCurvature.curly,
            'Cacheado',
            'Cabelo com cachos definidos em formato espiral.',
            provider,
          ),
          _buildCurvatureOption(
            context,
            HairCurvature.coily,
            'Crespo',
            'Cabelo com cachos muito densos e formato de "Z".',
            provider,
          ),
        ],
      ),
    );
  }

  Widget _buildCurvatureOption(
      BuildContext context,
      HairCurvature curvature,
      String title,
      String description,
      HairProfileProvider provider,
      ) {
    final isSelected = provider.curvature == curvature;

    return GestureDetector(
      onTap: () {
        provider.setCurvature(curvature);
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
                _getCurvatureIcon(curvature),
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

  IconData _getCurvatureIcon(HairCurvature curvature) {
    switch (curvature) {
      case HairCurvature.straight:
        return Icons.vertical_align_bottom;
      case HairCurvature.wavy:
        return Icons.waves;
      case HairCurvature.curly:
        return Icons.rotate_left;
      case HairCurvature.coily:
        return Icons.rotate_90_degrees_ccw;
    }
  }
}