import 'package:flutter/material.dart';
import 'package:oktay/data/announcements.dart';
import 'package:oktay/data/custom_user.dart';
import 'package:oktay/services/announcements_db.dart';
import 'package:oktay/services/attachments_db.dart';
import 'package:oktay/services/submissions_db.dart';
import 'package:oktay/services/updatealldata.dart';
import 'package:oktay/widgets/profile_tile.dart';
import 'package:oktay/data/submissions.dart';
import 'package:oktay/widgets/attachment_composer.dart';
import 'package:oktay/screens/teacher_classroom/submission_page.dart';
import 'package:oktay/screens/teacher_classroom/announcement_crud/edit_announcement.dart';
import 'package:provider/provider.dart';

class AnnouncementPage extends StatefulWidget {
  Announcement announcement;

  AnnouncementPage({required this.announcement});

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {

  List<Widget> buildSubmissions() {
    if(widget.announcement.type == 'Odev') {
      List submissionsAssigned = submissionList.where((i) => i.assignment == widget.announcement && !i.submitted).toList();
      List submissionsDone = submissionList.where((i) => i.assignment == widget.announcement && i.submitted).toList();
      return [
        if(submissionsDone.length > 0) Container(
          padding: EdgeInsets.only(top: 15, left: 15, bottom: 10),
          child: Text(
            "Yüklendi",
            style: TextStyle(
                fontSize: 20,
                color: widget.announcement.classroom.uiColor,
                letterSpacing: 1),
          ),
        ),
        if(submissionsDone.length > 0) Container(
          margin: EdgeInsets.only(left: 15),
          width: MediaQuery
              .of(context)
              .size
              .width - 30,
          height: 2,
          color: widget.announcement.classroom.uiColor,
        ),
        Container(
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: submissionsDone.length,
                itemBuilder: (context, int index) {
                  return InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => SubmissionPage(
                              submission:  submissionsDone[index]
                          ))),
                      child: Profile(
                          user: submissionsDone[index].user
                      ));
                })
        ),
        if(submissionsAssigned.length > 0) Container(
          padding: EdgeInsets.only(top: 15, left: 15, bottom: 10),
          child: Text(
            "Bekleniyor",
            style: TextStyle(
                fontSize: 20,
                color: widget.announcement.classroom.uiColor,
                letterSpacing: 1),
          ),
        ),
        if(submissionsAssigned.length > 0) Container(
          margin: EdgeInsets.only(left: 15),
          width: MediaQuery
              .of(context)
              .size
              .width - 30,
          height: 2,
          color: widget.announcement.classroom.uiColor,
        ),
        Container(
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: submissionsAssigned.length,
                itemBuilder: (context, int index) {
                  return Profile(
                          user: submissionsAssigned[index].user
                      );
                })
        )
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    Future<void> deleteAnnouncement() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sil'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text('Bu silinecek devam etmek ister misiniz?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Sil', style: TextStyle(color: Colors.red)),
                onPressed: () async {
                  print('Silindi');

                  await AnnouncementDB(user: user).deleteAnnouncements(widget.announcement.title, widget.announcement.classroom.className);

                  for(int i=0; i<widget.announcement.attachments.length; i++) {
                    var attachment = widget.announcement.attachments[i];
                    String safeURL = attachment.url.replaceAll(new RegExp(r'[^\w\s]+'),'');
                    AttachmentsDB().deleteAttachmentsDB(attachment.name, safeURL);

                    print("Silindi attachment");

                    AttachmentsDB().deleteAttachAnnounceDB(widget.announcement.title, safeURL);
                    print("Silindi reference to attachment on announcement");
                  }

                  if(widget.announcement.type == 'Odev') {
                    List students = widget.announcement.classroom.students;
                    for (int index = 0; index <
                        students.length; index++) {
                      await SubmissionDB(user: user).deleteSubmissions(students[index].uid,
                          widget.announcement.classroom.className,
                          widget.announcement.classroom.className+"__"+widget.announcement.title);
                    }
                  }

                  await updateAllData();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Vazgeç'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      body: ListView(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, left: 15, bottom: 10),
              child: Text(
                widget.announcement.title,
                style: TextStyle(
                    fontSize: 25, color: widget.announcement.classroom.uiColor, letterSpacing: 1),
              ),
            ),
            if(widget.announcement.type == 'Odev') Container(
              padding: EdgeInsets.only(left: 15, bottom: 10),
              child: Text(
                "Bitiş Tarihi " + widget.announcement.dueDate,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15),
              width: MediaQuery.of(context).size.width - 30,
              height: 2,
              color: widget.announcement.classroom.uiColor,
            ),
            Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 10),
                            CircleAvatar(
                              backgroundImage:
                              AssetImage("${widget.announcement.user.userDp}"),
                            ),
                            SizedBox(width: 10),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.announcement.user.firstName! + " " + widget.announcement.user.lastName!,
                                    style: TextStyle(),
                                  ),
                                  Text(
                                    "Son yükleme " + widget.announcement.dateTime,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ]),
                          ],
                        )
                      ],
                    ),
                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width - 40,
                        margin:
                        EdgeInsets.only(top: 15),
                        child: Text(widget.announcement.description)
                    )
                  ],
                )
            ),
            SizedBox(width: 10),
            widget.announcement.attachments.isNotEmpty ? Padding(
                padding: EdgeInsets.only(top: 15, left: 15, bottom: 10),
                child: Text(
                  "Ekler:",
                  style: TextStyle(
                      fontSize: 15, color: Colors.black, letterSpacing: 1, fontWeight: FontWeight.bold),
                )
            ) : Container(),
            AttachmentComposer(widget.announcement.attachments),
          ] + buildSubmissions()
      ),
      floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditAnnouncement(announcement: widget.announcement),
                    )).then((_) => setState(() {widget.announcement = getAnnouncement(widget.announcement.classroom.className, widget.announcement.title)!;}));
              },
              backgroundColor: widget.announcement.classroom.uiColor,
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 32,
              ),
              heroTag: null,
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () => deleteAnnouncement(),
              backgroundColor: widget.announcement.classroom.uiColor,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 32,
              ),
              heroTag: null,
            )
          ]
      )
    );
  }
}
