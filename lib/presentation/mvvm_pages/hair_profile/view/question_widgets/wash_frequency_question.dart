import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/theme.dart';
import '../../providers/hair_profile_provider.dart';

class WashFrequencyQuestion extends StatelessWidget {
  const WashFrequencyQuestion({super.key});

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
              'A frequência de lavagem ajuda a determinar o cronograma ideal para seus tratamentos.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textMedium,
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.opacity,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Quantas vezes por semana você lava o cabelo?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (provider.washFrequencyPerWeek > 1) {
                          provider.setWashFrequencyPerWeek(provider.washFrequencyPerWeek - 1);
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      iconSize: 40,
                      color: provider.washFrequencyPerWeek > 1
                          ? AppColors.primary
                          : Colors.grey[300],
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          provider.washFrequencyPerWeek.toString(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (provider.washFrequencyPerWeek < 7) {
                          provider.setWashFrequencyPerWeek(provider.washFrequencyPerWeek + 1);
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      iconSize: 40,
                      color: provider.washFrequencyPerWeek < 7
                          ? AppColors.primary
                          : Colors.grey[300],
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  _getWashFrequencyDescription(provider.washFrequencyPerWeek),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMedium,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getWashFrequencyDescription(int frequency) {
    switch (frequency) {
      case 1:
        return 'Uma vez por semana';
      case 2:
        return 'Duas vezes por semana (a cada 3-4 dias)';
      case 3:
        return 'Três vezes por semana (a cada 2-3 dias)';
      case 4:
        return 'Quatro vezes por semana (cerca de dia sim, dia não)';
      case 5:
        return 'Cinco vezes por semana (quase diariamente)';
      case 6:
        return 'Seis vezes por semana (quase diariamente)';
      case 7:
        return 'Todos os dias';
      default:
        return 'Selecione a frequência';
    }
  }
}