import 'package:flutter_crud_api_sample/src/model/profile.dart';
import 'package:flutter_crud_api_sample/src/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

import 'base_bloc.dart';

class CreateProfileBloc extends BaseBloc{
  final _repository = Repository();
  final _createProfileFetcher = PublishSubject<bool>();

  Observable<bool> get createProfile => _createProfileFetcher.stream;

  @override
   dispose() {
    _createProfileFetcher.close();
  }

  createData(Profile data) async {
    bool createProfile = await _repository.createProfile(data);
    _createProfileFetcher.sink.add(createProfile);
  }

}