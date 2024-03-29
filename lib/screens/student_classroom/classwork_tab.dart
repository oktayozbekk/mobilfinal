import 'package:flutter/material.dart';
import 'package:oktay/data/announcements.dart';
import 'package:oktay/data/custom_user.dart';
import 'package:oktay/screens/teacher_classroom/announcement_page.dart';
import 'package:provider/provider.dart';

class ClassWork extends StatefulWidget {
  final String className;

  ClassWork(this.className);

  @override
  _ClassWorkState createState() => _ClassWorkState();
}

class _ClassWorkState extends State<ClassWork> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    List _classWorkList = announcementList.where((i) => i.type == "Odev" && i.classroom.className == widget.className).toList();

    return ListView.builder(
        itemCount: _classWorkList.length,
        itemBuilder: (context, int index) {
          return InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AnnouncementPage(
                announcement: _classWorkList[index]
              ))),
            child:  Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: _classWorkList[index].classroom.uiColor),
                        child: Icon(
                          Icons.assignment,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _classWorkList[index].title,
                            style: TextStyle(letterSpacing: 1),
                          ),
                          Text(
                            "Bitiş " + _classWorkList[index].dueDate,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
            )
          );
        }
    );
  }
}
