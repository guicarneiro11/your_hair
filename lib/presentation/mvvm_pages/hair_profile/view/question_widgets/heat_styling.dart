import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/theme.dart';
import '../../providers/hair_profile_provider.dart';

class HeatStylingQuestion extends StatelessWidget {
  const HeatStylingQuestion({super.key});

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
              'Considere o uso de secador, chapinha, babyliss ou qualquer ferramenta de calor.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textMedium,
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          Container(
            padding: const EdgeInsets.all(16.0),
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
                SizedBox(
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildHeatToolIcon(Icons.invert_colors_off, 'Secador'),
                      _buildHeatToolIcon(Icons.straighten, 'Chapinha'),
                      _buildHeatToolIcon(Icons.rotate_left, 'Babyliss'),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Transform.scale(
                      scale: 1.3,
                      child: Switch(
                        value: provider.usesHeatStyling,
                        onChanged: (value) {
                          provider.setUsesHeatStyling(value);
                        },
                        activeColor: AppColors.primary,
                        activeTrackColor: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: Text(
                        provider.usesHeatStyling
                            ? 'Sim, eu uso ferramentas de calor no meu cabelo.'
                            : 'Não, eu não uso ferramentas de calor no meu cabelo.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatToolIcon(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}