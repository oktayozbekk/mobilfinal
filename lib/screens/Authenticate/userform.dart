// ignore_for_file: prefer_const_constructors

import 'package:oktay/data/custom_user.dart';
import 'package:oktay/screens/loading.dart';
import 'package:oktay/screens/wrapper.dart';
import 'package:oktay/services/accounts_db.dart';
import 'package:oktay/services/updatealldata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Userform extends StatefulWidget {
  const Userform({Key? key}) : super(key: key);

  @override
  _UserformState createState() => _UserformState();
}

class _UserformState extends State<Userform> {
  String firstname = "";
  String lastname = "";
  String type = "student";
  String error = "";

  // for form validation
  final _formKey = GlobalKey<FormState>();

  // for loading screen
  bool loading = false;



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);
    final AccountsDB pointer = AccountsDB(user: user!);

    return loading ? Loading() : Scaffold(
        appBar: AppBar(
          title: Text(
            "Kullanıcı Detayları",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          // form widget
          child: Form(

            // form key for validation( check above)
              key: _formKey,
              child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20.0),

                        // textbox for name
                        TextFormField(
                          decoration: InputDecoration(labelText: "Adınız", border: OutlineInputBorder()),
                          validator: (val) =>
                          val!.isEmpty ? 'Adınızı giriniz' : null,
                          onChanged: (val) {
                            setState(() {
                              firstname = val;
                            });
                          },
                        ),

                        SizedBox(height: 20.0),

                        // textbox for name
                        TextFormField(
                          decoration: InputDecoration(labelText: "Soyadınız", border: OutlineInputBorder()),
                          onChanged: (val) {
                            setState(() {
                              lastname = val;
                            });
                          },
                        ),

                        SizedBox(height: 20.0),


                        DropdownButtonFormField(
                          decoration: InputDecoration(labelText: "Kategori", border: OutlineInputBorder()),
                          value: "Ogrenci",
                          onChanged: (newValue) {
                            setState(() {
                              type = (newValue as String).toLowerCase();
                            });
                          },
                          items: ['Ogrenci', 'Ogretmen'].map((location) {
                            return DropdownMenuItem(
                              child: new Text(location),
                              value: location,
                            );
                          }).toList(),
                        ),

                        SizedBox(height: 20.0),


                        // register button
                        ElevatedButton(
                          child: Text("Kayıt Ol"),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);

                              // adding to db
                              await pointer.updateAccounts(firstname, lastname, type);

                              await updateAllData();

                              setState(() => loading = false);

                              // popping to Wrapper to go to class
                              Navigator.pushReplacement(context, MaterialPageRoute( builder: (context) => Wrapper()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),

                        SizedBox(height: 12.0),

                        // Prints error if any while registering
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    ),
                  ))),
        ));
  }
}
