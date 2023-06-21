

import 'package:oktay/data/accounts.dart';
import 'package:oktay/data/announcements.dart';
import 'package:oktay/data/attachments.dart';
import 'package:oktay/data/classrooms.dart';
import 'package:oktay/services/submissions_db.dart';

class Submission {
  Account user;
  String dateTime;
  ClassRooms classroom;
  Announcement assignment;
  bool submitted = false;
  List attachments;

  Submission({required this.user, this.dateTime = "", required this.classroom, required this.assignment, this.submitted = false, required this.attachments});
}

List submissionList = [];

Future<bool> getsubmissionList() async {
  submissionList = [];

  List? jsonList = await SubmissionDB().createSubmissionListDB();
  if (jsonList == null) return false;

  jsonList.forEach((element) {
    var data = element.data();
    var user = getAccount(data["uid"]);
    var classroom = getClassroom(data["classroom"]);
    var assignment = getAnnouncement(data["classroom"], data["assignment"]);

    if (user != null && classroom != null && assignment != null) {
      submissionList.add(
        Submission(
          user: user,
          classroom: classroom,
          assignment: assignment,
          dateTime: data["dateTime"],
          submitted: data["submitted"],
          attachments: getAttachmentListForStudent(data["uid"], data["classroom"], data["assignment"]),
        ),
      );
    }
  });

  return true;
}


// List<Submission> submissionList = [
//   Submission(
//     user: accountList[0],
//     dateTime: 'Aug 25, 8:40 PM',
//     classroom: classRoomList[0],
//     assignment: announcementList[8],
//     submitted: true
//   ),
//   Submission(
//       user: accountList[1],
//       classroom: classRoomList[0],
//       assignment: announcementList[8],
//   ),
// ];