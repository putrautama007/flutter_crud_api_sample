import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample/src/bloc/create_profile_bloc.dart';
import 'package:flutter_crud_api_sample/src/bloc/update_profile_bloc.dart';
import 'package:flutter_crud_api_sample/src/model/profile.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  Profile profile;

  FormAddScreen({this.profile});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;

  final createBloc = CreateProfileBloc();
  final updateBloc = UpdateProfileBloc();
  bool _isFieldNameValid;
  bool _isFieldEmailValid;
  bool _isFieldAgeValid;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerAge = TextEditingController();

  @override
  void initState() {
    checkProfile();
    super.initState();
  }

  @override
  void dispose() {
    createBloc.dispose();
    updateBloc.dispose();
    super.dispose();
  }

  checkProfile() {
    if (widget.profile != null) {
      _isFieldNameValid = true;
      _controllerName.text = widget.profile.name;
      _isFieldEmailValid = true;
      _controllerEmail.text = widget.profile.email;
      _isFieldAgeValid = true;
      _controllerAge.text = widget.profile.age.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.profile == null ? "Form Add" : "Change Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldName(),
                _buildTextFieldEmail(),
                _buildTextFieldAge(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    onPressed: () => onPress(),
                    child: Text(
                      widget.profile == null
                          ? "Submit".toUpperCase()
                          : "Update Data".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.orange[600],
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  onPress() {
    if (_isFieldNameValid == null ||
        _isFieldEmailValid == null ||
        _isFieldAgeValid == null ||
        !_isFieldNameValid ||
        !_isFieldEmailValid ||
        !_isFieldAgeValid) {
      _scaffoldState.currentState.showSnackBar(
        SnackBar(
          content: Text("Please fill all field"),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    String name = _controllerName.text.toString();
    String email = _controllerEmail.text.toString();
    int age = int.parse(_controllerAge.text.toString());
    Profile profile = Profile(name: name, email: email, age: age.toString());
    if (widget.profile == null) {
      createBloc.createData(profile);
      createBloc.createProfile.listen((isSuccess) {
        setState(() {
          _isLoading = false;
        });
        if (isSuccess == true) {
          Navigator.pop(context);
        } else {
          _scaffoldState.currentState.showSnackBar(SnackBar(
            content: Text("Submit data failed"),
          ));
        }
      });
    } else {
      profile.id = widget.profile.id;
      updateBloc.updateData(profile);
      updateBloc.updateProfile.listen((isSuccess) {
        setState(() => _isLoading = false);
        if (isSuccess) {
          Navigator.pop(context);
        } else {
          _scaffoldState.currentState.showSnackBar(SnackBar(
            content: Text("Update data failed"),
          ));
        }
      });
    }
  }

  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Full name",
        errorText: _isFieldNameValid == null || _isFieldNameValid
            ? null
            : "Full name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNameValid) {
          setState(() => _isFieldNameValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        errorText: _isFieldEmailValid == null || _isFieldEmailValid
            ? null
            : "Email is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldEmailValid) {
          setState(() => _isFieldEmailValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldAge() {
    return TextField(
      controller: _controllerAge,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Age",
        errorText: _isFieldAgeValid == null || _isFieldAgeValid
            ? null
            : "Age is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldAgeValid) {
          setState(() => _isFieldAgeValid = isFieldValid);
        }
      },
    );
  }
}
