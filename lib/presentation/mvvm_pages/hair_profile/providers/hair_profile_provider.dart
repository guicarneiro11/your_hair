import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../../data/models/hair_profile.dart';
import '../../../../domain/repositories/hair_profile_repository.dart';

class HairProfileProvider with ChangeNotifier {
  final HairProfileRepository _repository;

  HairCurvature? _curvature;
  HairLength? _length;
  HairThickness? _thickness;
  HairOiliness? _oiliness;
  HairDamage? _damage;
  bool _usesHeatStyling = false;
  bool _wantsUmectacao = false;
  bool _wantsTonalizacao = false;
  bool _usesAcidificante = false;
  bool _wantsHairColorRetouching = false;
  bool _wantsHighlightRetouching = false;
  bool _wantsStraighteningRetouching = false;
  bool _hasHairExtensions = false;
  bool _hasBraids = false;
  bool _hasDreads = false;
  bool _needsAntiHairLossTreatment = false;
  bool _needsDandruffTreatment = false;
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
  bool get wantsUmectacao => _wantsUmectacao;
  bool get wantsTonalizacao => _wantsTonalizacao;
  bool get usesAcidificante => _usesAcidificante;
  bool get wantsHairColorRetouching => _wantsHairColorRetouching;
  bool get wantsHighlightRetouching => _wantsHighlightRetouching;
  bool get wantsStraighteningRetouching => _wantsStraighteningRetouching;
  bool get hasHairExtensions => _hasHairExtensions;
  bool get hasBraids => _hasBraids;
  bool get hasDreads => _hasDreads;
  bool get needsAntiHairLossTreatment => _needsAntiHairLossTreatment;
  bool get needsDandruffTreatment => _needsDandruffTreatment;
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

  void setWantsUmectacao(bool value) {
    _wantsUmectacao = value;
    notifyListeners();
  }

  void setWantsTonalizacao(bool value) {
    _wantsTonalizacao = value;
    notifyListeners();
  }

  void setUsesAcidificante(bool value) {
    _usesAcidificante = value;
    notifyListeners();
  }

  void setWantsHairColorRetouching(bool value) {
    _wantsHairColorRetouching = value;
    notifyListeners();
  }

  void setWantsHighlightRetouching(bool value) {
    _wantsHighlightRetouching = value;
    notifyListeners();
  }

  void setWantsStraighteningRetouching(bool value) {
    _wantsStraighteningRetouching = value;
    notifyListeners();
  }

  void setHasHairExtensions(bool value) {
    _hasHairExtensions = value;
    notifyListeners();
  }

  void setHasBraids(bool value) {
    _hasBraids = value;
    notifyListeners();
  }

  void setHasDreads(bool value) {
    _hasDreads = value;
    notifyListeners();
  }

  void setNeedsAntiHairLossTreatment(bool value) {
    _needsAntiHairLossTreatment = value;
    notifyListeners();
  }

  void setNeedsDandruffTreatment(bool value) {
    _needsDandruffTreatment = value;
    notifyListeners();
  }

  HairProfile? createProfile() {
    // Verificar se todos os campos obrigatórios estão preenchidos
    if (_curvature == null ||
        _length == null ||
        _thickness == null ||
        _oiliness == null ||
        _damage == null ||
        _elasticity == null ||
        _porosity == null ||
        _lastCutDate == null) {
      return null; // Não é possível criar um perfil completo
    }

    // Criar e retornar o perfil com todos os campos
    return HairProfile(
      id: const Uuid().v4(), // Gerar ID único usando UUID
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

      // Campos adicionais
      wantsUmectacao: _wantsUmectacao,
      wantsTonalizacao: _wantsTonalizacao,
      usesAcidificante: _usesAcidificante,
      wantsHairColorRetouching: _wantsHairColorRetouching,
      wantsHighlightRetouching: _wantsHighlightRetouching,
      wantsStraighteningRetouching: _wantsStraighteningRetouching,
      hasHairExtensions: _hasHairExtensions,
      hasBraids: _hasBraids,
      hasDreads: _hasDreads,
      needsAntiHairLossTreatment: _needsAntiHairLossTreatment,
      needsDandruffTreatment: _needsDandruffTreatment,
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

        // Carregar novos campos
        _wantsUmectacao = _currentProfile!.wantsUmectacao;
        _wantsTonalizacao = _currentProfile!.wantsTonalizacao;
        _usesAcidificante = _currentProfile!.usesAcidificante;
        _wantsHairColorRetouching = _currentProfile!.wantsHairColorRetouching;
        _wantsHighlightRetouching = _currentProfile!.wantsHighlightRetouching;
        _wantsStraighteningRetouching = _currentProfile!.wantsStraighteningRetouching;
        _hasHairExtensions = _currentProfile!.hasHairExtensions;
        _hasBraids = _currentProfile!.hasBraids;
        _hasDreads = _currentProfile!.hasDreads;
        _needsAntiHairLossTreatment = _currentProfile!.needsAntiHairLossTreatment;
        _needsDandruffTreatment = _currentProfile!.needsDandruffTreatment;
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

    _wantsUmectacao = false;
    _wantsTonalizacao = false;
    _usesAcidificante = false;
    _wantsHairColorRetouching = false;
    _wantsHighlightRetouching = false;
    _wantsStraighteningRetouching = false;
    _hasHairExtensions = false;
    _hasBraids = false;
    _hasDreads = false;
    _needsAntiHairLossTreatment = false;
    _needsDandruffTreatment = false;

    notifyListeners();
  }
}