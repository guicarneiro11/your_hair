import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../app/theme.dart';
import '../../providers/hair_profile_provider.dart';

class AdditionalTreatmentsQuestion extends StatelessWidget {
  const AdditionalTreatmentsQuestion({super.key});

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
              'Selecione os tratamentos adicionais que deseja incluir no seu cronograma:',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textMedium,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          _buildTreatmentOption(
            context,
            'Umectação Noturna',
            'Aplicação de óleos capilares para dormir, protegendo os fios e aumentando a nutrição.',
            Icons.nightlight_round,
            provider.wantsUmectacao,
                (value) => provider.setWantsUmectacao(value),
          ),
          _buildTreatmentOption(
            context,
            'Tonalização/Matização',
            'Tratamento com pigmentos para manter ou corrigir a cor dos cabelos.',
            Icons.color_lens,
            provider.wantsTonalizacao,
                (value) => provider.setWantsTonalizacao(value),
          ),
          _buildTreatmentOption(
            context,
            'Acidificante',
            'Tratamento para equilibrar o pH do cabelo e melhorar o fechamento das cutículas.',
            Icons.science,
            provider.usesAcidificante,
                (value) => provider.setUsesAcidificante(value),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentOption(
      BuildContext context,
      String title,
      String description,
      IconData icon,
      bool isSelected,
      Function(bool) onChanged,
      ) {
    return Container(
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
              icon,
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
          Switch(
            value: isSelected,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}