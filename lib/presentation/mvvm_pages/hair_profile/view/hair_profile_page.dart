import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_hair/presentation/mvvm_pages/hair_profile/view/question_widgets/additional_treatments_question.dart';
import 'package:your_hair/presentation/mvvm_pages/hair_profile/view/question_widgets/heat_styling.dart';
import '../../../../app/theme.dart';
import '../providers/hair_profile_provider.dart';
import 'question_widgets/curvature_question.dart';
import 'question_widgets/length_question.dart';
import 'question_widgets/thickness_question.dart';
import 'question_widgets/oiliness_question.dart';
import 'question_widgets/damage_question.dart';
import 'question_widgets/elasticity_question.dart';
import 'question_widgets/porosity_question.dart';
import 'question_widgets/wash_frequency_question.dart';
import 'question_widgets/last_cut_question.dart';
import 'question_widgets/chemical_treatment_question.dart';

class HairProfilePage extends StatefulWidget {
  const HairProfilePage({super.key});

  @override
  State<HairProfilePage> createState() => _HairProfilePageState();
}

class _HairProfilePageState extends State<HairProfilePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _questions = [
    const CurvatureQuestion(),
    const LengthQuestion(),
    const ThicknessQuestion(),
    const OilinessQuestion(),
    const DamageQuestion(),
    const HeatStylingQuestion(),
    const ElasticityQuestion(),
    const PorosityQuestion(),
    const WashFrequencyQuestion(),
    const LastCutQuestion(),
    const ChemicalTreatmentQuestion(),
    const AdditionalTreatmentsQuestion()
  ];

  final List<String> _questionTitles = [
    'Qual é o tipo de curvatura do seu cabelo?',
    'Qual é o comprimento do seu cabelo?',
    'Qual é a espessura dos fios do seu cabelo?',
    'Qual é o nível de oleosidade do seu cabelo?',
    'Qual é o nível de danos do seu cabelo?',
    'Você usa ferramentas de calor no seu cabelo?',
    'Como está a elasticidade do seu cabelo?',
    'Qual é a porosidade do seu cabelo?',
    'Quantas vezes por semana você lava o cabelo?',
    'Quando foi seu último corte de cabelo?',
    'Você fez algum tratamento químico recentemente?',
    'Quais tratamentos adicionais você deseja incluir?',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishQuestionnaire();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishQuestionnaire() {
    final provider = Provider.of<HairProfileProvider>(context, listen: false);
    final profile = provider.createProfile();

    if (profile != null) {
      provider.saveProfile(profile).then((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Informações Incompletas'),
          content: const Text('Por favor, responda todas as perguntas para continuar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Seu Perfil Capilar'),
        leading: _currentPage > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousPage,
        )
            : IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          _buildQuestionTitle(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: _questions,
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: LinearProgressIndicator(
        value: (_currentPage + 1) / _questions.length,
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        borderRadius: BorderRadius.circular(10),
        minHeight: 8,
      ),
    );
  }

  Widget _buildQuestionTitle() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        _questionTitles[_currentPage],
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _nextPage,
          child: Text(
            _currentPage < _questions.length - 1 ? 'Próximo' : 'Finalizar',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}