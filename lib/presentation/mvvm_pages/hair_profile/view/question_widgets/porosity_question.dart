import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/theme.dart';
import '../../../../../data/models/hair_profile.dart';
import '../../providers/hair_profile_provider.dart';

class PorosityQuestion extends StatelessWidget {
  const PorosityQuestion({super.key});

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
              'Teste de porosidade: Coloque um fio de cabelo limpo em um copo com água. Se afundar rapidamente, é alta porosidade. Se flutuar, é baixa. Se afundar lentamente, é média.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textMedium,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildPorosityOption(
            context,
            HairPorosity.low,
            'Baixa',
            'Água demora a penetrar no cabelo. Repele água e produtos. Demora a secar.',
            provider,
          ),
          _buildPorosityOption(
            context,
            HairPorosity.medium,
            'Média',
            'Equilíbrio na absorção de água e produtos. Tempo de secagem médio.',
            provider,
          ),
          _buildPorosityOption(
            context,
            HairPorosity.high,
            'Alta',
            'Absorve água e produtos rapidamente. Seca muito rápido. Tende a ficar com frizz.',
            provider,
          ),
        ],
      ),
    );
  }

  Widget _buildPorosityOption(
      BuildContext context,
      HairPorosity porosity,
      String title,
      String description,
      HairProfileProvider provider,
      ) {
    final isSelected = provider.porosity == porosity;

    return GestureDetector(
      onTap: () {
        provider.setPorosity(porosity);
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
                child: _buildPorosityIndicator(porosity),
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

  Widget _buildPorosityIndicator(HairPorosity porosity) {
    IconData icon;
    double size;

    switch (porosity) {
      case HairPorosity.low:
        icon = Icons.water_drop_outlined;
        size = 30;
        break;
      case HairPorosity.medium:
        icon = Icons.water;
        size = 30;
        break;
      case HairPorosity.high:
        icon = Icons.water_drop;
        size = 40;
        break;
    }

    return Icon(
      icon,
      color: AppColors.primary,
      size: size,
    );
  }
}