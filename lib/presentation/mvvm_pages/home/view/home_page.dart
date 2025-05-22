import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';
import '../../../../data/models/hair_profile.dart';
import '../../../../data/models/schedule.dart';
import '../../../../data/models/treatment.dart';
import '../providers/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ValueNotifier<DateTime> _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedDay = ValueNotifier(DateTime.now());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).loadSchedule();
    });
  }

  @override
  void dispose() {
    _selectedDay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text('Erro: ${provider.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => provider.loadSchedule(),
                child: const Text('Tentar Novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.activeSchedule == null || provider.profile == null) {
      return _buildNoScheduleView(provider);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seu Cronograma',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            Text(
              'Cronograma personalizado baseado no seu perfil',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.regenerateSchedule(),
            tooltip: 'Regenerar Cronograma',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'redo_questionnaire':
                  _showRedoQuestionnaireDialog();
                  break;
                case 'profile':
                  _showProfileInfo(provider.profile);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'redo_questionnaire',
                child: Row(
                  children: [
                    Icon(Icons.quiz, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Refazer Questionário'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('Meu Perfil'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendar(provider),
          const SizedBox(height: 8),
          _buildSelectedDayEvents(provider),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/schedule-details');
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.calendar_view_week, color: Colors.white),
      ),
    );
  }

  Widget _buildNoScheduleView(HomeProvider provider) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_today,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Nenhum Cronograma Encontrado',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Vamos criar um cronograma personalizado para o seu cabelo!',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => provider.generateSchedule(),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Gerar Cronograma'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(HomeProvider provider) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: provider.activeSchedule?.startDate ?? DateTime.now(),
        lastDay: provider.activeSchedule?.endDate ?? DateTime.now().add(const Duration(days: 60)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay.value, day),
        eventLoader: (day) => provider.getEventsForDay(day),
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: CalendarStyle(
          markersMaxCount: 3,
          markerDecoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay.value = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _buildSelectedDayEvents(HomeProvider provider) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: _selectedDay,
      builder: (context, selectedDay, _) {
        final events = provider.getEventsForDay(selectedDay);

        if (events.isEmpty) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_available,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum tratamento para este dia',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    DateFormat.yMMMd().format(selectedDay),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final treatment = provider.getTreatmentById(event.treatmentId);

                      return _buildEventCard(event, treatment);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventCard(ScheduleEvent event, Treatment? treatment) {
    if (treatment == null) {
      return const SizedBox.shrink();
    }

    Color treatmentColor;

    switch (treatment.type) {
      case TreatmentType.hydration:
        treatmentColor = AppColors.hydration;
        break;
      case TreatmentType.nutrition:
        treatmentColor = AppColors.nutrition;
        break;
      case TreatmentType.reconstruction:
        treatmentColor = AppColors.reconstruction;
        break;
      case TreatmentType.detox:
        treatmentColor = AppColors.detox;
        break;
      case TreatmentType.haircut:
        treatmentColor = AppColors.haircut;
        break;
      default:
        treatmentColor = AppColors.special;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: treatmentColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getTreatmentIcon(treatment.type),
            color: treatmentColor,
          ),
        ),
        title: Text(
          treatment.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              treatment.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Checkbox(
          value: event.isCompleted,
          activeColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          onChanged: (value) {
            if (value != null) {
              Provider.of<HomeProvider>(context, listen: false)
                  .updateEventCompletion(event, value);
            }
          },
        ),
        onTap: () {
          _showTreatmentDetails(treatment, event);
        },
      ),
    );
  }

  IconData _getTreatmentIcon(TreatmentType type) {
    switch (type) {
      case TreatmentType.hydration:
        return Icons.water_drop;
      case TreatmentType.nutrition:
        return Icons.local_florist;
      case TreatmentType.reconstruction:
        return Icons.construction;
      case TreatmentType.detox:
        return Icons.cleaning_services;
      case TreatmentType.exfoliation:
        return Icons.bubble_chart;
      case TreatmentType.oilTreatment:
        return Icons.opacity;
      case TreatmentType.haircut:
        return Icons.content_cut;
      case TreatmentType.colorTouch:
        return Icons.color_lens;
      case TreatmentType.hairMask:
        return Icons.face;
      case TreatmentType.chemicalTreatment:
        return Icons.science;
      case TreatmentType.special:
        return Icons.star;
    }
  }

  void _showTreatmentDetails(Treatment treatment, ScheduleEvent event) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6, // Um pouco menor
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    treatment.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.category, 'Tipo', _getTreatmentTypeText(treatment.type)),
                  const SizedBox(height: 16),
                  const Text(
                    'Descrição',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(treatment.description),
                  if (treatment.productRecommendations != null &&
                      treatment.productRecommendations!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Produtos Sugeridos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(treatment.productRecommendations!),
                  ],
                ],
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<HomeProvider>(context, listen: false)
                            .updateEventCompletion(event, !event.isCompleted);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: event.isCompleted ? Colors.grey[200] : AppColors.primary,
                        foregroundColor: event.isCompleted ? AppColors.textDark : Colors.white,
                      ),
                      child: Text(event.isCompleted ? 'Marcar como Pendente' : 'Marcar como Concluído'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _getTreatmentTypeText(TreatmentType type) {
    switch (type) {
      case TreatmentType.hydration:
        return 'Hidratação';
      case TreatmentType.nutrition:
        return 'Nutrição';
      case TreatmentType.reconstruction:
        return 'Reconstrução';
      case TreatmentType.detox:
        return 'Detox';
      case TreatmentType.exfoliation:
        return 'Esfoliação';
      case TreatmentType.oilTreatment:
        return 'Tratamento com Óleo';
      case TreatmentType.haircut:
        return 'Corte de Cabelo';
      case TreatmentType.colorTouch:
        return 'Retoque de Cor';
      case TreatmentType.hairMask:
        return 'Máscara Capilar';
      case TreatmentType.chemicalTreatment:
        return 'Tratamento Químico';
      case TreatmentType.special:
        return 'Tratamento Especial';
    }
  }

  void _showRedoQuestionnaireDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Refazer Questionário'),
        content: const Text(
          'Você deseja refazer o questionário do seu perfil capilar?\n\n'
              'Isso irá substituir suas respostas atuais e gerar um novo cronograma personalizado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/hair-profile');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Sim, Refazer'),
          ),
        ],
      ),
    );
  }

  void _showProfileInfo(HairProfile? profile) {
    if (profile == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                'Meu Perfil Capilar',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildProfileItem('Curvatura', _getCurvatureText(profile.curvature), Icons.waves),
                    _buildProfileItem('Comprimento', _getLengthText(profile.length), Icons.straighten),
                    _buildProfileItem('Espessura', _getThicknessText(profile.thickness), Icons.linear_scale),
                    _buildProfileItem('Oleosidade', _getOilinessText(profile.oiliness), Icons.water_drop),
                    _buildProfileItem('Danos', _getDamageText(profile.damage), Icons.warning_amber),
                    _buildProfileItem('Usa Calor', profile.usesHeatStyling ? 'Sim' : 'Não', Icons.whatshot),
                    _buildProfileItem('Elasticidade', _getElasticityText(profile.elasticity), Icons.open_with),
                    _buildProfileItem('Porosidade', _getPorosityText(profile.porosity), Icons.bubble_chart),
                    _buildProfileItem('Lavagem por Semana', '${profile.washFrequencyPerWeek}x', Icons.local_laundry_service),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showRedoQuestionnaireDialog();
                },
                child: const Text('Refazer Questionário'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getCurvatureText(HairCurvature curvature) {
    switch (curvature) {
      case HairCurvature.straight: return 'Liso';
      case HairCurvature.wavy: return 'Ondulado';
      case HairCurvature.curly: return 'Cacheado';
      case HairCurvature.coily: return 'Crespo';
    }
  }

  String _getLengthText(HairLength length) {
    switch (length) {
      case HairLength.short: return 'Curto';
      case HairLength.medium: return 'Médio';
      case HairLength.long: return 'Longo';
    }
  }

  String _getThicknessText(HairThickness thickness) {
    switch (thickness) {
      case HairThickness.fine: return 'Fino';
      case HairThickness.medium: return 'Médio';
      case HairThickness.thick: return 'Grosso';
    }
  }

  String _getOilinessText(HairOiliness oiliness) {
    switch (oiliness) {
      case HairOiliness.dry: return 'Seco';
      case HairOiliness.normal: return 'Normal';
      case HairOiliness.oily: return 'Oleoso';
    }
  }

  String _getDamageText(HairDamage damage) {
    switch (damage) {
      case HairDamage.none: return 'Sem Danos';
      case HairDamage.light: return 'Danos Leves';
      case HairDamage.moderate: return 'Danos Moderados';
      case HairDamage.severe: return 'Danos Severos';
    }
  }

  String _getElasticityText(HairElasticity elasticity) {
    switch (elasticity) {
      case HairElasticity.low: return 'Baixa';
      case HairElasticity.medium: return 'Média';
      case HairElasticity.high: return 'Alta';
    }
  }

  String _getPorosityText(HairPorosity porosity) {
    switch (porosity) {
      case HairPorosity.low: return 'Baixa';
      case HairPorosity.medium: return 'Média';
      case HairPorosity.high: return 'Alta';
    }
  }
}