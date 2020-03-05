import 'package:cafe_manager/main_screen/manager_services/cafe_services/update_widgets/drink_update.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/update_widgets/foods_update.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/update_widgets/hookah_update.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderUpdate extends StatefulWidget {
  final String cafeName;

  const OrderUpdate({Key key, this.cafeName}) : super(key: key);
  @override
  _OrderUpdateState createState() => _OrderUpdateState();
}

class _OrderUpdateState extends State<OrderUpdate>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تعديل الطلبات"),
        bottom: TabBar(
          labelStyle: TextStyle(fontSize: 20, fontFamily: 'topaz'),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text: 'المعسلات',
            ),
            Tab(
              text: 'المطعم',
            ),
            Tab(
              text: 'المشروبات',
            ),
          ],
          controller: _controller,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: TabBarView(
            children: <Widget>[
              HookahUpdate(),
              FoodsUpdate(),
              DrinkUdate(),
            ],
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
