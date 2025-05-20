import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/theme.dart';
import '../../../../../data/models/hair_profile.dart';
import '../../providers/hair_profile_provider.dart';

class ElasticityQuestion extends StatelessWidget {
  const ElasticityQuestion({super.key});

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
              'Teste de elasticidade: Pegue um fio de cabelo molhado e estique-o suavemente. Observe quanto ele estica antes de quebrar ou voltar ao tamanho original.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textMedium,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildElasticityOption(
            context,
            HairElasticity.low,
            'Baixa',
            'O cabelo quase não estica ou quebra facilmente quando puxado.',
            provider,
          ),
          _buildElasticityOption(
            context,
            HairElasticity.medium,
            'Média',
            'O cabelo estica um pouco e retorna ao estado original sem quebrar.',
            provider,
          ),
          _buildElasticityOption(
            context,
            HairElasticity.high,
            'Alta',
            'O cabelo estica bastante antes de voltar ao tamanho original.',
            provider,
          ),
        ],
      ),
    );
  }

  Widget _buildElasticityOption(
      BuildContext context,
      HairElasticity elasticity,
      String title,
      String description,
      HairProfileProvider provider,
      ) {
    final isSelected = provider.elasticity == elasticity;

    return GestureDetector(
      onTap: () {
        provider.setElasticity(elasticity);
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
              child: _buildElasticityIndicator(elasticity),
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

  Widget _buildElasticityIndicator(HairElasticity elasticity) {
    IconData icon;

    switch (elasticity) {
      case HairElasticity.low:
        icon = Icons.maximize;
        break;
      case HairElasticity.medium:
        icon = Icons.linear_scale;
        break;
      case HairElasticity.high:
        icon = Icons.open_with;
        break;
    }

    return Icon(
      icon,
      color: AppColors.primary,
      size: 30,
    );
  }
}