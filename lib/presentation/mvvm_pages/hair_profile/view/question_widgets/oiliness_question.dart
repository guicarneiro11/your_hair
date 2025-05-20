import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/theme.dart';
import '../../../../../data/models/hair_profile.dart';
import '../../providers/hair_profile_provider.dart';

class OilinessQuestion extends StatelessWidget {
  const OilinessQuestion({super.key});

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
              'Dica: Considere quantos dias seu cabelo fica sem oleosidade excessiva após a lavagem.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textMedium,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildOilinessOption(
            context,
            HairOiliness.dry,
            'Seco',
            'Cabelo que raramente fica oleoso, com tendência a ressecamento e pontas duplas.',
            provider,
          ),
          _buildOilinessOption(
            context,
            HairOiliness.normal,
            'Normal',
            'Cabelo que fica oleoso após 2-3 dias da lavagem, com equilíbrio de oleosidade.',
            provider,
          ),
          _buildOilinessOption(
            context,
            HairOiliness.oily,
            'Oleoso',
            'Cabelo que fica oleoso rapidamente, com excesso de oleosidade na raiz.',
            provider,
          ),
        ],
      ),
    );
  }

  Widget _buildOilinessOption(
      BuildContext context,
      HairOiliness oiliness,
      String title,
      String description,
      HairProfileProvider provider,
      ) {
    final isSelected = provider.oiliness == oiliness;

    return GestureDetector(
      onTap: () {
        provider.setOiliness(oiliness);
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
                _getOilinessIcon(oiliness),
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

  IconData _getOilinessIcon(HairOiliness oiliness) {
    switch (oiliness) {
      case HairOiliness.dry:
        return Icons.water_drop_outlined;
      case HairOiliness.normal:
        return Icons.water_drop;
      case HairOiliness.oily:
        return Icons.opacity;
    }
  }
}