import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../../app/theme.dart';
import '../../providers/hair_profile_provider.dart';

class ChemicalTreatmentQuestion extends StatelessWidget {
  const ChemicalTreatmentQuestion({super.key});

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
              'Tratamentos químicos incluem coloração, descoloração, relaxamento, alisamento, permanente, etc.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.textMedium,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
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
                  Icons.science,
                  size: 64,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24.0),
                Text(
                  'Você fez algum tratamento químico recentemente?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _showChemicalTreatmentDialog(context, provider);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: provider.lastChemicalTreatmentDate != null
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: provider.lastChemicalTreatmentDate != null
                                  ? AppColors.primary
                                  : Colors.grey[300]!,
                              width: provider.lastChemicalTreatmentDate != null ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            'Sim',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: provider.lastChemicalTreatmentDate != null
                                  ? AppColors.primary
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          provider.setLastChemicalTreatmentDate(null);
                          provider.setChemicalTreatmentType(null);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: provider.lastChemicalTreatmentDate == null
                                ? AppColors.primary.withOpacity(0.1)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: provider.lastChemicalTreatmentDate == null
                                  ? AppColors.primary
                                  : Colors.grey[300]!,
                              width: provider.lastChemicalTreatmentDate == null ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            'Não',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: provider.lastChemicalTreatmentDate == null
                                  ? AppColors.primary
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (provider.lastChemicalTreatmentDate != null) ...[
                  const SizedBox(height: 24.0),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.science,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Tipo: ${provider.chemicalTreatmentType ?? ""}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 20,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Data: ${dateFormat.format(provider.lastChemicalTreatmentDate!)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () => _showChemicalTreatmentDialog(context, provider),
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Editar'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChemicalTreatmentDialog(BuildContext context, HairProfileProvider provider) {
    final treatmentTypeController = TextEditingController(text: provider.chemicalTreatmentType);
    final dateFormat = DateFormat('dd/MM/yyyy');
    DateTime selectedDate = provider.lastChemicalTreatmentDate ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Tratamento Químico'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: treatmentTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Tratamento',
                    hintText: 'Ex: Coloração, Alisamento...',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Data: '),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(DateTime.now().year - 2),
                          lastDate: DateTime.now(),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: AppColors.primary,
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.textDark,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        dateFormat.format(selectedDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final treatmentType = treatmentTypeController.text.trim();

                  if (treatmentType.isNotEmpty) {
                    provider.setLastChemicalTreatmentDate(selectedDate);
                    provider.setChemicalTreatmentType(treatmentType);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, informe o tipo de tratamento.'),
                      ),
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      ),
    );
  }
}