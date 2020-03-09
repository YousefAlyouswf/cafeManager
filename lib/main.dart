import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/login.dart';
import 'main_screen/cafes_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String cafeName;
  String phone;
  Future<String> isLogined() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String isLogin = prefs.getString('cafeName');
    phone = prefs.getString('phone');
    //-------------- For firebase notifications

    FirebaseMessaging().requestNotificationPermissions();

    FirebaseMessaging().configure(onMessage: (Map<String, dynamic> message) {
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

//-----------------END
    return isLogin;
  }

  @override
  void initState() {
    isLogined().then((onValue) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        cafeName = onValue;
        if (cafeName != null ) {
          String userID = prefs.getString('userID');
          FirebaseMessaging().getToken().then((token) {
            print('token: $token');
            Firestore.instance
                .collection('manager')
                .document(userID)
                .updateData({'pushToken': token});
          }).catchError((err) {});
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: cafeName == null || cafeName == '' || cafeName == "مدير"
          ? Login()
          : CafesScreen(
              cafeName: cafeName,
              phone: phone,
            ),
    );
  }
}
