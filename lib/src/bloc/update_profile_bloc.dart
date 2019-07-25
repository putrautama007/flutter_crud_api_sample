import 'package:flutter_crud_api_sample/src/model/profile.dart';
import 'package:flutter_crud_api_sample/src/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

import 'base_bloc.dart';

class UpdateProfileBloc extends BaseBloc{

  final _repository = Repository();
  final _updateProfileFetcher = PublishSubject<bool>();

  Observable<bool> get updateProfile => _updateProfileFetcher.stream;

  @override
  dispose() {
    _updateProfileFetcher.close();
    return null;
  }

  updateData(Profile data) async {
    bool createProfile = await _repository.updateProfile(data);
    _updateProfileFetcher.sink.add(createProfile);
  }

}