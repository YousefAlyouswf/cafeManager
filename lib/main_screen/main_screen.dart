import 'package:flutter/material.dart';

import 'manager_services/add_cafe.dart';
import 'manager_services/cafe_list.dart';
import 'manager_services/view_contact.dart';
import 'manager_services/user_accounts.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> services = [
    'أظافة مقهى',
    'عدد المقاهي',
    'المستخدمين',
    'أرقام التواصل'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        centerTitle: true,
        title: Text("الإدارة العامة"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: services.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCafe()),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CafeList()),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsersAccounts()),
                );
              } else if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewContact()),
                );
              }
            },
            child: Card(
              child: Center(
                child: Text(
                  services[index],
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
