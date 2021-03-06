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
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Center(
            child: Text("صفحة الدخول"),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: height * 0.1,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontFamily: 'topaz'),
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
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontFamily: 'topaz'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(128, 0, 0, 0.8),
                    ),
                    child: Builder(
                      builder: (context) => InkWell(
                        onTap: () async {
                          String level;
                          String userID;
                          final QuerySnapshot userinfo = await Firestore
                              .instance
                              .collection('manager')
                              .where("password", isEqualTo: password)
                              .where("phone", isEqualTo: phone)
                              .getDocuments();
                          final List<DocumentSnapshot> documents =
                              userinfo.documents;
                          documents.forEach((f) {
                            level = f['cafe'];
                            userID = f.documentID;
                          });
                          if (password.isEmpty ||
                              password == '' ||
                              password == null ||
                              phone == '' ||
                              phone == null ||
                              phone.isEmpty) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red[900],
                              content: Text(
                                'يوجد حقل فارغ',
                                textAlign: TextAlign.end,
                                style: TextStyle(fontSize: 18),
                              ),
                              duration: Duration(seconds: 3),
                            ));
                          } else {
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

                                FirebaseMessaging()
                                    .requestNotificationPermissions();

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
                            } else {
                              print("Error");
                              Scaffold.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.red[900],
                                content: Text(
                                  'البيانات غير صحيحة',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(fontSize: 18),
                                ),
                                duration: Duration(seconds: 3),
                              ));
                            }
                          }
                        },
                        splashColor: Colors.red,
                        borderRadius: BorderRadius.circular(50),
                        child: Center(
                          child: Text(
                            "دخول",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'topaz',
                                fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
