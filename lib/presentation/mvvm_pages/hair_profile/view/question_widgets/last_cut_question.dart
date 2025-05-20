import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../../app/theme.dart';
import '../../providers/hair_profile_provider.dart';

class LastCutQuestion extends StatelessWidget {
  const LastCutQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HairProfileProvider>(context);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Esta informação ajuda a calcular o próximo corte necessário.',
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
                  Icons.content_cut,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Último Corte de Cabelo',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Text(
                  provider.lastCutDate != null
                      ? dateFormat.format(provider.lastCutDate!)
                      : 'Selecione uma data',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: provider.lastCutDate != null
                        ? AppColors.textDark
                        : AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 24.0),
                ElevatedButton.icon(
                  onPressed: () => _selectDate(context, provider),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Escolher Data'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, HairProfileProvider provider) async {
    final now = DateTime.now();
    final initialDate = provider.lastCutDate ?? now;
    final firstDate = DateTime(now.year - 2, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? now : initialDate,
      firstDate: firstDate,
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      provider.setLastCutDate(pickedDate);
    }
  }
}