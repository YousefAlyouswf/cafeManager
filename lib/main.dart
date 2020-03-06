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
    return isLogin;
  }

  @override
  void initState() {
    isLogined().then((onValue) {
      setState(() {
        cafeName = onValue;
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
