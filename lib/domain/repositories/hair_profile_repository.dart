import '../../data/models/hair_profile.dart';

abstract class HairProfileRepository {
  Future<HairProfile?> getProfile();
  Future<void> saveProfile(HairProfile profile);
  Future<void> updateProfile(HairProfile profile);
  Future<void> deleteProfile();
}