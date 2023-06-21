import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:oktay/data/custom_user.dart';
import 'package:oktay/services/classes_db.dart';
import 'package:oktay/services/updatealldata.dart';
import 'package:provider/provider.dart';

class AddClass extends StatefulWidget {

  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {

  String className = "";
  String description = "";
  Color uiColor = Colors.blue;
  Color _tempShadeColor = Colors.blue;

  // for form validation
  final _formKey = GlobalKey<FormState>();

  void _openDialog(String title, Widget content) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(6.0),
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              child: Text('Vazgeç'),
              onPressed: Navigator.of(context).pop,
            ),
            TextButton(
              child: Text('Seç'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => uiColor = _tempShadeColor);
              },
            ),
          ],
        );
      },
    );
  }

  void _openColorPicker() async {
    _openDialog(
      "Renk Seç",
      MaterialColorPicker(
        selectedColor: uiColor,
        onColorChange: (color) => setState(() => _tempShadeColor = color)
      ),
    );
  }

  // build func
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return Scaffold(
      // appbar part
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0.5,
          title: Text(
            "Sınıf Ekle",
            style: TextStyle(
                color: Colors.white, fontFamily: "Roboto", fontSize: 22),
          ),
       
        ),

        // body part
        body: ListView(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0),

                    TextFormField(
                      decoration: InputDecoration(labelText: "Sınıf Adı", border: OutlineInputBorder()),
                      validator: (val) => val!.isEmpty ? 'Enter a class name' : null,
                      onChanged: (val) {
                        setState(() {
                          className = val;
                        });
                      },
                    ),

                    SizedBox(height: 20.0),

                    TextFormField(
                      decoration: InputDecoration(labelText: "Açıklama", border: OutlineInputBorder()),
                      maxLines: 5,
                      onChanged: (val) {
                        setState(() {
                          description = val;
                        });
                      },
                    ),

                    SizedBox(height: 20.0),


                    OutlinedButton(
                      onPressed: () {
                        _openColorPicker();
                        setState(() => {});
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Renk",
                                style: TextStyle(color: Colors.black87, fontSize: 14)),
                            CircleColor(
                              color: uiColor,
                              circleSize: 30,
                              onColorChoose: (color) {
                                setState(() => {uiColor = color});
                              },
                            ),
                          ]
                        )
                      )
                    ),

                    SizedBox(height: 20.0),

                    // Login  button
                    ElevatedButton(
                      child: Text("Ekle",
                          style: TextStyle(
                              color: Colors.white, fontFamily: "Roboto",
                              fontSize: 22)
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate())  {
                          await ClassesDB(user: user).updateClasses(className, description, uiColor);
                          await updateAllData();

                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(150, 50),
                      ),
                    )
                  ],
                ))],
        ));
  }
}