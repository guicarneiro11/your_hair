import '../models/treatment.dart';
import '../data_sources/local/hive_data_source.dart';
import '../../domain/repositories/treatment_repository.dart';

class TreatmentRepositoryImpl implements TreatmentRepository {
  @override
  Future<List<Treatment>> getAllTreatments() async {
    final box = HiveDataSource.getTreatmentBox();
    return box.values.toList();
  }

  @override
  Future<Treatment?> getTreatmentById(String id) async {
    final box = HiveDataSource.getTreatmentBox();
    return box.get(id);
  }

  @override
  Future<void> saveTreatment(Treatment treatment) async {
    final box = HiveDataSource.getTreatmentBox();
    await box.put(treatment.id, treatment);
  }

  @override
  Future<void> updateTreatment(Treatment treatment) async {
    final box = HiveDataSource.getTreatmentBox();
    await box.put(treatment.id, treatment);
  }

  @override
  Future<void> deleteTreatment(String id) async {
    final box = HiveDataSource.getTreatmentBox();
    await box.delete(id);
  }
}