import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_manager/main_screen/main_screen.dart';
import 'package:cafe_manager/main_screen/cafes_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String phone;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("صفحة الدخول"),
        ),
      ),
      body: Container(
        color: Colors.red[50],
        child: Padding(
          padding: const EdgeInsets.all(42.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        phone = val;
                      });
                    },
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'رقم الجوال',
                      hintStyle:
                          TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  textAlign: TextAlign.end,
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'كلمة المرور',
                    hintStyle: TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                  ),
                ),
              ),
              RaisedButton(
                  child: Text("دخول"),
                  onPressed: () async {
                    String level;
                    final QuerySnapshot userinfo = await Firestore.instance
                        .collection('manager')
                        .where("password", isEqualTo: password)
                        .where("phone", isEqualTo: phone)
                        .getDocuments();
                    final List<DocumentSnapshot> documents = userinfo.documents;
                    documents.forEach((f) {
                      level = f['cafe'];
                    });
                    if (documents.length == 1) {
                      if (level == 'مدير') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return MainScreen();
                            },
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return CafesScreen(cafeName: level,);
                            },
                          ),
                        );
                      }
                    } else {}
                  })
            ],
          ),
        ),
      ),
    );
  }
}
