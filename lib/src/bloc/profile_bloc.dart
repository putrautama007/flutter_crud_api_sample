import 'package:flutter_crud_api_sample/src/model/profile.dart';
import 'package:flutter_crud_api_sample/src/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

import 'base_bloc.dart';

class ProfileBloc implements BaseBloc{
  final _repository = Repository();
  final _profileFetcher = PublishSubject<List<Profile>>();

  Observable<List<Profile>> get getProfile => _profileFetcher.stream;

  @override
  dispose() {
    _profileFetcher.close();
  }

  fetchData() async {
    List<Profile> profileList = await _repository.getProfile();
    _profileFetcher.sink.add(profileList);
  }


}