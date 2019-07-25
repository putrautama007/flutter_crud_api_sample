import 'package:flutter/material.dart';
import 'package:flutter_crud_api_sample/src/bloc/delete_profile_bloc.dart';
import 'package:flutter_crud_api_sample/src/bloc/profile_bloc.dart';
import 'package:flutter_crud_api_sample/src/model/profile.dart';

import 'form_add_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BuildContext context;

  final profileBloc = ProfileBloc();
  final deleteProfileBloc = DeleteProfileBloc();

  @override
  void initState() {
    super.initState();
    profileBloc.fetchData();
  }

  @override
  void didChangeDependencies() {
    profileBloc.fetchData();
    super.didChangeDependencies();
  }


  @override
  void dispose() {
    profileBloc.dispose();
    deleteProfileBloc.dispose();
    super.dispose();
  }

  toAddForm(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => FormAddScreen()));
  }

  updateForm(BuildContext context, Profile profile) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FormAddScreen(profile: profile);
    }));
  }

  deleteData(BuildContext context, Profile profile) {
    this.context = context;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text(
                "Are you sure want to delete data profile ${profile.name}?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  Navigator.pop(context);
                  deleteProfileBloc.deleteData(profile.id);
                  deleteProfileBloc.deleteProfile.listen((isSuccess){
                    if (isSuccess = true) {
                      setState(() {
                        profileBloc.fetchData();
                      });
                      Scaffold.of(this.context).showSnackBar(
                          SnackBar(content: Text("Delete data success")));
                    } else {
                      Scaffold.of(this.context).showSnackBar(
                          SnackBar(content: Text("Delete data failed")));
                    }
                  });
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter CRUD"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => toAddForm(context),
            iconSize: MediaQuery.of(context).size.width / 12,
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: profileBloc.getProfile,
            builder:
                (BuildContext context, AsyncSnapshot<List<Profile>> snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                      "Something wrong with message: ${snapshot.error.toString()}"),
                );
              } else if (snapshot.hasData) {
                List<Profile> profiles = snapshot.data;
                return _buildListView(profiles);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }

  Widget _buildListView(List<Profile> profiles) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          Profile profile = profiles[index];
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                    Text(profile.email),
                    Text(profile.age.toString()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            deleteData(context, profile);
                          },
                          child: Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            updateForm(context, profile);
                          },
                          child: Text(
                            "Edit",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: profiles.length,
      ),
    );
  }
}
