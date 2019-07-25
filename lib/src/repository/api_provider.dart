import 'package:flutter_crud_api_sample/src/model/profile.dart';
import 'package:http/http.dart' show Client;

class ApiProvider{
  final String baseUrl = "http://api.bengkelrobot.net:8001";
  Client _client = Client();
  
  Future<List<Profile>> getProfiles() async{
    final response = await _client.get("$baseUrl/profile");
    if(response.statusCode == 200)
      return profileFromJson(response.body);
    else
      return null;
  }

  Future<bool> createProfile(Profile data) async {
    final response = await _client.post(
      "$baseUrl/profile",
      headers: {"content-type": "application/json"},
      body: profileToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProfile(Profile data) async {
    final response = await _client.put(
      "$baseUrl/profile/${data.id}",
      headers: {"content-type": "application/json"},
      body: profileToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProfile(int id) async {
    final response = await _client.delete(
      "$baseUrl/profile/$id",
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}