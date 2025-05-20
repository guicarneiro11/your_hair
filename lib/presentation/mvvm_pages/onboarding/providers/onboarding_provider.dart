import 'package:flutter/foundation.dart';
import '../../../../data/models/hair_profile.dart';

class OnboardingProvider with ChangeNotifier {
  int _currentStep = 0;
  bool _onboardingCompleted = false;

  HairCurvature? _curvature;
  HairLength? _length;
  HairThickness? _thickness;
  HairOiliness? _oiliness;
  HairDamage? _damage;
  bool _usesHeatStyling = false;
  HairElasticity? _elasticity;
  HairPorosity? _porosity;
  int _washFrequencyPerWeek = 3;
  DateTime? _lastCutDate;
  DateTime? _lastChemicalTreatmentDate;
  String? _chemicalTreatmentType;

  int get currentStep => _currentStep;
  bool get onboardingCompleted => _onboardingCompleted;

  HairCurvature? get curvature => _curvature;
  HairLength? get length => _length;
  HairThickness? get thickness => _thickness;
  HairOiliness? get oiliness => _oiliness;
  HairDamage? get damage => _damage;
  bool get usesHeatStyling => _usesHeatStyling;
  HairElasticity? get elasticity => _elasticity;
  HairPorosity? get porosity => _porosity;
  int get washFrequencyPerWeek => _washFrequencyPerWeek;
  DateTime? get lastCutDate => _lastCutDate;
  DateTime? get lastChemicalTreatmentDate => _lastChemicalTreatmentDate;
  String? get chemicalTreatmentType => _chemicalTreatmentType;

  void nextStep() {
    _currentStep++;
    notifyListeners();
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void completeOnboarding() {
    _onboardingCompleted = true;
    notifyListeners();
  }

  void setCurvature(HairCurvature value) {
    _curvature = value;
    notifyListeners();
  }

  void setLength(HairLength value) {
    _length = value;
    notifyListeners();
  }

  void setThickness(HairThickness value) {
    _thickness = value;
    notifyListeners();
  }

  void setOiliness(HairOiliness value) {
    _oiliness = value;
    notifyListeners();
  }

  void setDamage(HairDamage value) {
    _damage = value;
    notifyListeners();
  }

  void setUsesHeatStyling(bool value) {
    _usesHeatStyling = value;
    notifyListeners();
  }

  void setElasticity(HairElasticity value) {
    _elasticity = value;
    notifyListeners();
  }

  void setPorosity(HairPorosity value) {
    _porosity = value;
    notifyListeners();
  }

  void setWashFrequencyPerWeek(int value) {
    _washFrequencyPerWeek = value;
    notifyListeners();
  }

  void setLastCutDate(DateTime value) {
    _lastCutDate = value;
    notifyListeners();
  }

  void setLastChemicalTreatmentDate(DateTime value) {
    _lastChemicalTreatmentDate = value;
    notifyListeners();
  }

  void setChemicalTreatmentType(String value) {
    _chemicalTreatmentType = value;
    notifyListeners();
  }

  HairProfile? createProfile() {
    if (_curvature == null ||
        _length == null ||
        _thickness == null ||
        _oiliness == null ||
        _damage == null ||
        _elasticity == null ||
        _porosity == null ||
        _lastCutDate == null) {
      return null;
    }

    return HairProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      curvature: _curvature!,
      length: _length!,
      thickness: _thickness!,
      oiliness: _oiliness!,
      damage: _damage!,
      usesHeatStyling: _usesHeatStyling,
      elasticity: _elasticity!,
      porosity: _porosity!,
      washFrequencyPerWeek: _washFrequencyPerWeek,
      lastCutDate: _lastCutDate!,
      lastChemicalTreatmentDate: _lastChemicalTreatmentDate,
      chemicalTreatmentType: _chemicalTreatmentType,
    );
  }

  void reset() {
    _currentStep = 0;
    _onboardingCompleted = false;
    _curvature = null;
    _length = null;
    _thickness = null;
    _oiliness = null;
    _damage = null;
    _usesHeatStyling = false;
    _elasticity = null;
    _porosity = null;
    _washFrequencyPerWeek = 3;
    _lastCutDate = null;
    _lastChemicalTreatmentDate = null;
    _chemicalTreatmentType = null;
    notifyListeners();
  }
}