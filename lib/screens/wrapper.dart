// ignore_for_file: prefer_const_constructors

import 'package:oktay/data/accounts.dart';
import 'package:oktay/data/custom_user.dart';
import 'package:oktay/screens/Authenticate/authenticate.dart';
import 'package:oktay/screens/student_homepage.dart';
import 'package:oktay/screens/teacher_homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key ? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {


    // getting user from the Stream Provider
    final user = Provider.of<CustomUser?>(context);

    // logic for if logged in
    if (user != null && accountExists(user.uid)) {
      var typeOfCurrentUser = getAccount(user.uid)!.type;
      return typeOfCurrentUser == 'student'? StudentHomePage() : TeacherHomePage();
    }


    // user isnt logged in
    else return Authenticate();

  }
}
