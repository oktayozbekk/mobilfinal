import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oktay/data/quotes.dart';
import 'package:oktay/services/api.dart';

class ApiScreen extends StatefulWidget {
  ApiScreen({Key? key}) : super(key: key);

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  String _responseData = '';
    String _response = '';
  var size, height, width;

  Quotes? data;
  @override
  Widget build(BuildContext context) {
    Future<void> postData() async {
      var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      var response = await http.post(url, body: {
        'title': 'Flutter',
        'body': 'Test',
        'userId': '1',
      });

      if (response.statusCode == 201) {
        setState(() {
          _responseData = response.body;
          _response = "API Yazma işlemi başarılı.";

        });
      } else {
        setState(() {
          _responseData = 'API isteği başarısız oldu.';
        });
      }
    }

    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: Text(" Rastegele Sözler"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_outlined,
            ),
            iconSize: 30,
            onPressed: () {
              print("icon refresh");
              getQuotes();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: getQuotes,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                "Yenilemek için aşağıya kaydırın",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: width / 2,
              child: Card(
                margin: EdgeInsets.only(top: 20),
                color: Color(0XFFeeeeee),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${data?.content ?? "Ne yaptığından ya da ne yapacağından bahsetme"}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 22),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            data?.author ?? "Thomas Jefferson",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
             SizedBox(height: 40),
            ElevatedButton(
              onPressed: postData,
              child: Text('Veri Yaz'),
            ),
                SizedBox(height: 20),
             
            Text(
              _response,
              style: TextStyle(fontSize: 16),
            ),
             SizedBox(height: 20),

            Text(
              _responseData,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> getQuotes() async {
    data = await Api.getQuotes();
    setState(() {});
  }
}
