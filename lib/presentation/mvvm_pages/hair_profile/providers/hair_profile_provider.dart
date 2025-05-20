import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../../data/models/hair_profile.dart';
import '../../../../data/repositories/hair_profile_repository.dart';
import '../../../../domain/repositories/hair_profile_repository.dart';

class HairProfileProvider with ChangeNotifier {
  final HairProfileRepository _repository;

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

  HairProfile? _currentProfile;
  bool _isLoading = false;
  String? _error;

  HairProfileProvider(this._repository) {
    _loadCurrentProfile();
  }

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

  HairProfile? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasProfile => _currentProfile != null;

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

  void setLastChemicalTreatmentDate(DateTime? value) {
    _lastChemicalTreatmentDate = value;
    notifyListeners();
  }

  void setChemicalTreatmentType(String? value) {
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
      id: const Uuid().v4(),
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

  Future<void> _loadCurrentProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentProfile = await _repository.getProfile();

      if (_currentProfile != null) {
        _curvature = _currentProfile!.curvature;
        _length = _currentProfile!.length;
        _thickness = _currentProfile!.thickness;
        _oiliness = _currentProfile!.oiliness;
        _damage = _currentProfile!.damage;
        _usesHeatStyling = _currentProfile!.usesHeatStyling;
        _elasticity = _currentProfile!.elasticity;
        _porosity = _currentProfile!.porosity;
        _washFrequencyPerWeek = _currentProfile!.washFrequencyPerWeek;
        _lastCutDate = _currentProfile!.lastCutDate;
        _lastChemicalTreatmentDate = _currentProfile!.lastChemicalTreatmentDate;
        _chemicalTreatmentType = _currentProfile!.chemicalTreatmentType;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile(HairProfile profile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.saveProfile(profile);
      _currentProfile = profile;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(HairProfile profile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateProfile(profile);
      _currentProfile = profile;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.deleteProfile();
      _currentProfile = null;
      _resetState();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _resetState() {
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