import '../../domain/repositories/hair_profile_repository.dart';
import '../models/hair_profile.dart';
import '../data_sources/local/hive_data_source.dart';

class HairProfileRepositoryImpl implements HairProfileRepository {
  @override
  Future<HairProfile?> getProfile() async {
    final box = HiveDataSource.getHairProfileBox();

    if (box.isEmpty) {
      return null;
    }

    return box.values.first;
  }

  @override
  Future<void> saveProfile(HairProfile profile) async {
    final box = HiveDataSource.getHairProfileBox();

    await box.clear();

    await box.put(profile.id, profile);
  }

  @override
  Future<void> updateProfile(HairProfile profile) async {
    final box = HiveDataSource.getHairProfileBox();
    await box.put(profile.id, profile);
  }

  @override
  Future<void> deleteProfile() async {
    final box = HiveDataSource.getHairProfileBox();
    await box.clear();
  }
}