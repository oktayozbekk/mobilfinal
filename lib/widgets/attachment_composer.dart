import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(url) async {
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}


class AttachmentComposer extends StatefulWidget {
  List attachmentList;

  AttachmentComposer(this.attachmentList);

  @override
  _AttachmentComposerState createState() => _AttachmentComposerState();
}

class _AttachmentComposerState extends State<AttachmentComposer> {
  @override
  Widget build(BuildContext context) {

    return Container(
        child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: widget.attachmentList.length,
            itemBuilder: (context, int index) {
              return InkWell(
                  onTap: () {
                    _launchUrl(Uri.parse(widget.attachmentList[index].url));
                    // OpenFile.open(widget.attachmentList[index].url);
                  },
                  child: Container(
                      margin: EdgeInsets.only(
                          left: 15, right: 15, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 0.05)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                  size: 30,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
      widget.attachmentList[index].name.length > 20 
        ? widget.attachmentList[index].name.substring(0, 20) + '...' 
        : widget.attachmentList[index].name,
      style: TextStyle(fontSize: 15, letterSpacing: 1),
    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                  ));
            })
    );
  }
}
