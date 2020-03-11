import 'dart:io';
import 'package:cafe_manager/login/login.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/add_order.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/add_seats.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/add_account.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/daelete_account.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/all_seats.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/order_update.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manager_services/cafe_services/change_password.dart';
import 'manager_services/cafe_services/code_change.dart';
import 'manager_services/cafe_services/help.dart';

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

  TextEditingController controller = TextEditingController();
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
    'تغيير كلمة المرور',
    'للمساعدة',
  ];
  Color cardColor;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("cafeName", null);
        prefs.setString('phone', null);
        prefs.setString('userID', null);
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return Login();
            },
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Text("مقهى ${widget.cafeName} ${widget.phone}"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('seats')
                .document(widget.cafeName)
                .snapshots(),
            builder: (context, snapshot) {
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    cardColor = Colors.green[300];
                  } else if (index == 1) {
                    cardColor = Colors.green[300];
                  } else if (index == 9) {
                    cardColor = Colors.red[50];
                  } else {
                    cardColor = Colors.grey;
                  }
                  return Card(
                    child: InkWell(
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
                          _showDialog(context).then((onValue) {
                            if (snapshot.data['password'] == onValue)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddSeats(
                                    cafeName: widget.cafeName,
                                  ),
                                ),
                              );
                          });
                        } else if (index == 3) {
                          _showDialog(context).then((onValue) {
                            if (snapshot.data['password'] == onValue)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddOrders(
                                    cafeName: widget.cafeName,
                                  ),
                                ),
                              );
                          });
                        } else if (index == 4) {
                          _showDialog(context).then((onValue) {
                            if (snapshot.data['password'] == onValue)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderUpdate(
                                    cafeName: widget.cafeName,
                                  ),
                                ),
                              );
                          });
                        } else if (index == 5) {
                          _showDialog(context).then((onValue) {
                            if (snapshot.data['password'] == onValue)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CodeChange(
                                    cafeName: widget.cafeName,
                                  ),
                                ),
                              );
                          });
                        } else if (index == 6) {
                          _showDialog(context).then((onValue) {
                            if (snapshot.data['password'] == onValue)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AddAccount(cafeName: widget.cafeName)),
                              );
                          });
                        } else if (index == 7) {
                          _showDialog(context).then((onValue) {
                            if (snapshot.data['password'] == onValue)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DeleteAcount(
                                        cafeName: widget.cafeName)),
                              );
                          });
                        } else if (index == 8) {
                          _showDialog(context).then((onValue) {
                            if (snapshot.data['password'] == onValue)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChagnePassword(
                                        cafeName: widget.cafeName)),
                              );
                          });
                        } else if (index == 9) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Help()),
                          );
                        }
                      },
                      child: Card(
                        color: cardColor,
                        child: Center(
                          child: Text(
                            services[index],
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800),
                          ),
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
              );
            }),
      ),
    );
  }

  Future<String> _showDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => new _SystemPadding(
        child: new AlertDialog(
          title: Text(
            'دخول إدارة',
            textAlign: TextAlign.end,
            style: TextStyle(color: Colors.blue),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  keyboardType: TextInputType.number,
                  controller: controller,
                  textAlign: TextAlign.end,
                  autofocus: true,
                  decoration: new InputDecoration(
                    hintText: 'كلمة مرور الادارة',
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('خروج'),
                onPressed: () {
                  Navigator.pop(context);
                  controller.clear();
                }),
            new FlatButton(
                child: const Text('إدخال'),
                onPressed: () {
                  Navigator.of(context).pop(controller.text.toString());
                  controller.clear();
                })
          ],
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
        duration: const Duration(milliseconds: 300), child: child);
  }
}
