import 'package:flutter/material.dart';
import 'package:oktay/data/custom_user.dart';
import 'package:oktay/screens/student_classroom/people_tab.dart';
import 'package:provider/provider.dart';

import '../student_classroom/classwork_tab.dart';
import '../student_classroom/stream_tab.dart';
import 'package:oktay/data/classrooms.dart';

class ClassRoomPage extends StatefulWidget {
  ClassRooms classRoom;
  Color uiColor;

  ClassRoomPage({required this.classRoom, required this.uiColor});

  @override
  _ClassRoomPageState createState() => _ClassRoomPageState();
}

class _ClassRoomPageState extends State<ClassRoomPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    String className = widget.classRoom.className;
    Color uiColor = widget.uiColor;

    final tabs = [
      StreamTab(
        className: className,
        uiColor: uiColor
      ),
      ClassWork(className),
      PeopleTab(
          classRoom: widget.classRoom,
          uiColor: uiColor
      )
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: uiColor,
        elevation: 0.5,
        title: Text(
          className,
          style: TextStyle(
              color: Colors.white, fontFamily: "Roboto", fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "En Son",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Sınıf Çalışması',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Katılımcılar',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: uiColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
