import 'dart:io';

import 'package:cafe_manager/login/login.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/add_order.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/add_seats.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/add_account.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/daelete_account.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/all_seats.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/order_update.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manager_services/cafe_services/code_change.dart';

class CafesScreen extends StatefulWidget {
  final String cafeName;
  final String phone;
  const CafesScreen({Key key, this.cafeName, this.phone}) : super(key: key);
  @override
  _CafesScreenState createState() => _CafesScreenState();
}

class _CafesScreenState extends State<CafesScreen> {
  FirebaseMessaging _firebaseMessaging;

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Services(
        //       cafeName: widget.cafeName,
        //       phone: widget.phone,
        //     ),
        //   ),
        // );
      },
      onLaunch: (Map<String, dynamic> message) async {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => Services(
        //       cafeName: widget.cafeName,
        //       phone: widget.phone,
        //     ),
        //   ),
        // );
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void initState() {
    super.initState();
    setUpFirebase();
  }

  List<String> services = [
    'خدمة',
    'متابعة الجلسات',
    'إظافة جلسات',
    'إظافة طلبات',
    'حذف الطلبات',
    'تغيير الرمز',
    'إظافة حساب',
    'معلومات الموظفين',
  ];
  Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("مقهى ${widget.cafeName} ${widget.phone}"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("cafeName", null);
                prefs.setString('phone', null);
                prefs.setString('userID', null);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return Login();
                    },
                  ),
                );
              })
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: services.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            cardColor = Colors.red[300];
          } else if (index == 1) {
            cardColor = Colors.red[300];
          } else {
            cardColor = Colors.grey;
          }
          return InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Services(
                      cafeName: widget.cafeName,
                      phone: widget.phone,
                    ),
                  ),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllSeats(
                      cafeName: widget.cafeName,
                      phone: widget.phone,
                    ),
                  ),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddSeats(
                      cafeName: widget.cafeName,
                    ),
                  ),
                );
              } else if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddOrders(
                      cafeName: widget.cafeName,
                    ),
                  ),
                );
              } else if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderUpdate(
                      cafeName: widget.cafeName,
                    ),
                  ),
                );
              } else if (index == 5) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CodeChange(
                      cafeName: widget.cafeName,
                    ),
                  ),
                );
              } else if (index == 6) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddAccount(cafeName: widget.cafeName)),
                );
              } else if (index == 7) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DeleteAcount(cafeName: widget.cafeName)),
                );
              }
            },
            child: Card(
              color: cardColor,
              child: Center(
                child: Text(
                  services[index],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
