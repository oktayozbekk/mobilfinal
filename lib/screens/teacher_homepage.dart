import 'package:flutter/material.dart';
import 'package:oktay/data/accounts.dart';
import 'package:oktay/screens/Todo/todo.dart';
import 'package:oktay/screens/teacher_classroom/add_class.dart';
import 'package:oktay/screens/teacher_classroom/classes_tab.dart';
import 'package:oktay/screens/APITest/ApiScreen.dart';
import 'package:oktay/services/auth.dart';
import 'package:oktay/data/custom_user.dart';
import 'package:provider/provider.dart';

class TeacherHomePage extends StatefulWidget {
  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final user = Provider.of<CustomUser?>(context);
    var account = getAccount(user!.uid);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "Sınıflarım",
          style: TextStyle(
              color: Colors.black, fontFamily: "Roboto", fontSize: 22),
        ),
        backgroundColor: Colors.white,
        actions: [
         
          IconButton(
            icon: Icon(
              Icons.next_week_rounded,
              color: Colors.black87,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ApiScreen(
                 
                ),
              ));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.book,
              color: Colors.black87,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TodoListScreen(
                 
                ),
              ));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.black87,
              size: 30,
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: ClassesTab(account),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => AddClass(),
              ))
              .then((_) => setState(() {}));
        },
        backgroundColor: Colors.orange,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
