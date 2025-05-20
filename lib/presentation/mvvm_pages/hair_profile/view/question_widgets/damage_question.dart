import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/theme.dart';
import '../../../../../data/models/hair_profile.dart';
import '../../providers/hair_profile_provider.dart';

class DamageQuestion extends StatelessWidget {
  const DamageQuestion({super.key});

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
              'Considere a quantidade de tratamentos químicos, uso de calor e sinais visíveis de danos.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textMedium,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildDamageOption(
            context,
            HairDamage.none,
            'Sem Danos',
            'Cabelo natural, sem química, com pontas saudáveis e sem sinais de quebra.',
            provider,
          ),
          _buildDamageOption(
            context,
            HairDamage.light,
            'Danos Leves',
            'Algumas pontas duplas, uso ocasional de ferramentas de calor ou coloração suave.',
            provider,
          ),
          _buildDamageOption(
            context,
            HairDamage.moderate,
            'Danos Moderados',
            'Pontas ressecadas, descoloração ou alisamento recente, uso frequente de calor.',
            provider,
          ),
          _buildDamageOption(
            context,
            HairDamage.severe,
            'Danos Severos',
            'Quebra frequente, porosidade alta, múltiplos processos químicos, pontas muito danificadas.',
            provider,
          ),
        ],
      ),
    );
  }

  Widget _buildDamageOption(
      BuildContext context,
      HairDamage damage,
      String title,
      String description,
      HairProfileProvider provider,
      ) {
    final isSelected = provider.damage == damage;

    return GestureDetector(
      onTap: () {
        provider.setDamage(damage);
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
              child: _buildDamageIndicator(damage),
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

  Widget _buildDamageIndicator(HairDamage damage) {
    IconData icon;

    switch (damage) {
      case HairDamage.none:
        icon = Icons.check_circle;
        break;
      case HairDamage.light:
        icon = Icons.fiber_manual_record;
        break;
      case HairDamage.moderate:
        icon = Icons.warning_amber;
        break;
      case HairDamage.severe:
        icon = Icons.dangerous;
        break;
    }

    return Icon(
      icon,
      color: AppColors.primary,
      size: 30,
    );
  }
}