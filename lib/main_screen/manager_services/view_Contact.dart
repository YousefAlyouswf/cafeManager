import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewContact extends StatefulWidget {
  @override
  _ViewContactState createState() => _ViewContactState();
}

class _ViewContactState extends State<ViewContact> {
  String phone;
  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text("للمساعدة"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: Firestore.instance.collection('help').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("");
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "رقم الجوال",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FlatButton(
                              onPressed: () => launch(
                                  "tel:${snapshot.data.documents[index].data['phone']}"),
                              child: Text(
                                "${snapshot.data.documents[index].data['phone']}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              "البريد الإلكتروني",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FlatButton(
                              onPressed: () => launch(
                                  "mailto:${snapshot.data.documents[index].data['email']}"),
                              child: Text(
                                "${snapshot.data.documents[index].data['email']}",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'رقم الجوال',
                                suffixIcon: Icon(Icons.phone_iphone),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontFamily: 'topaz'),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  phone = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'البريد الاكتروني',
                                suffixIcon: Icon(Icons.mail),
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontFamily: 'topaz'),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Builder(
                              builder: (BuildContext context) {
                                return RaisedButton(
                                  onPressed: () {
                                    Firestore.instance
                                        .collection('help')
                                        .document('PjfOtpvcc4Ld4rnUgCTS')
                                        .updateData({
                                      'phone': phone,
                                      'email': email,
                                    });

                                    SnackBar mySnackBar = SnackBar(
                                      content: Text(
                                        "تم بنجاح",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      backgroundColor: Colors.green,
                                      duration:
                                          const Duration(milliseconds: 500),
                                    );
                                    Scaffold.of(context)
                                        .showSnackBar(mySnackBar);
                                  },
                                  child: Text(
                                    "تغيير",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                  ),
                                  color: Colors.green[400],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
