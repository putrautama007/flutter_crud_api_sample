import 'package:flutter_crud_api_sample/src/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

import 'base_bloc.dart';

class DeleteProfileBloc extends BaseBloc{
  final _repository = Repository();
  final _deleteProfileFetcher = PublishSubject<bool>();

  Observable<bool> get deleteProfile => _deleteProfileFetcher.stream;


  deleteData(int id) async{
    bool createProfile = await _repository.deleteProfile(id);
    _deleteProfileFetcher.sink.add(createProfile);
  }

  @override
  dispose() {
    _deleteProfileFetcher.close();
  }

}