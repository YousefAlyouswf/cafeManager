import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_manager/main_screen/main_screen.dart';
import 'package:cafe_manager/main_screen/cafes_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
                    hintStyle:
                        TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                  ),
                ),
              ),
              RaisedButton(
                  child: Text("دخول"),
                  onPressed: () async {
                    String level;
                    String userID;
                    final QuerySnapshot userinfo = await Firestore.instance
                        .collection('manager')
                        .where("password", isEqualTo: password)
                        .where("phone", isEqualTo: phone)
                        .getDocuments();
                    final List<DocumentSnapshot> documents = userinfo.documents;
                    documents.forEach((f) {
                      level = f['cafe'];
                      userID = f.documentID;
                    });
                    if (documents.length == 1) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("cafeName", level);
                      prefs.setString("phone", phone);
                      prefs.setString('userID', userID);
                      if (level == 'مدير') {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return MainScreen();
                            },
                          ),
                        );
                      } else {
//-------------- For firebase notifications

                        FirebaseMessaging().requestNotificationPermissions();

                        FirebaseMessaging().configure(
                            onMessage: (Map<String, dynamic> message) {
                          return;
                        }, onResume: (Map<String, dynamic> message) {
                          print('onResume: $message');
                          return;
                        }, onLaunch: (Map<String, dynamic> message) {
                          print('onLaunch: $message');
                          return;
                        });

                        FirebaseMessaging().getToken().then((token) {
                          print('token: $token');
                          Firestore.instance
                              .collection('manager')
                              .document(userID)
                              .updateData({'pushToken': token});
                        }).catchError((err) {});

//-----------------END

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return CafesScreen(
                                cafeName: level,
                                phone: phone,
                              );
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
