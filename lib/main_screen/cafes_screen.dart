import 'package:cafe_manager/main_screen/manager_services/cafe_services/add_order.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/add_seats.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/all_seats.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/order_update.dart';
import 'package:cafe_manager/main_screen/manager_services/cafe_services/services.dart';
import 'package:flutter/material.dart';

class CafesScreen extends StatefulWidget {
  final String cafeName;

  const CafesScreen({Key key, this.cafeName}) : super(key: key);
  @override
  _CafesScreenState createState() => _CafesScreenState();
}

class _CafesScreenState extends State<CafesScreen> {
  List<String> services = [
    'خدمة',
    'متابعة الجلسات',
    'إظافة جلسات',
    'إظافة طلبات',
    'تعديل الطلبات',
  ];
  Color cardColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إدارة مقهى ${widget.cafeName}"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: services.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            cardColor = Colors.red[300];
          }else if(index==1){
            cardColor = Colors.red[300];
          } else {
            cardColor=Colors.grey;
          }
          return InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Services(
                      cafeName: widget.cafeName,
                    ),
                  ),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllSeats(
                      cafeName: widget.cafeName,
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
