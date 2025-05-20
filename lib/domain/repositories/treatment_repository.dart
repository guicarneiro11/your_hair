import '../../data/models/treatment.dart';

abstract class TreatmentRepository {
  Future<List<Treatment>> getAllTreatments();
  Future<Treatment?> getTreatmentById(String id);
  Future<void> saveTreatment(Treatment treatment);
  Future<void> updateTreatment(Treatment treatment);
  Future<void> deleteTreatment(String id);
}