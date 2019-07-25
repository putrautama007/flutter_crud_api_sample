import 'package:flutter_crud_api_sample/src/model/profile.dart';

import 'api_provider.dart';

class Repository{
  final apiProvider = ApiProvider();
  Future<List<Profile>> getProfile() => apiProvider.getProfiles();
  Future<bool> createProfile(Profile data) => apiProvider.createProfile(data);
  Future<bool> updateProfile(Profile data) => apiProvider.updateProfile(data);
  Future<bool> deleteProfile(int id) => apiProvider.deleteProfile(id);
}