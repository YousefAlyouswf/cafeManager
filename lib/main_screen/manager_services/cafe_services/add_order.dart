import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddOrders extends StatefulWidget {
  final String cafeName;

  const AddOrders({Key key, this.cafeName}) : super(key: key);

  @override
  _AddOrdersState createState() => _AddOrdersState();
}

class _AddOrdersState extends State<AddOrders> {
  String orderName;
  String orderPrice;
  String section;
  String msgErr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إظافة طلبات"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'أسم الطلب',
                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                ),
                onChanged: (val) {
                  setState(() {
                    orderName = val;
                  });
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'سعر الطلب',
                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                ),
                onChanged: (val) {
                  setState(() {
                    orderPrice = val;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButton<String>(
                items: [
                  DropdownMenuItem<String>(
                    value: "معسلات",
                    child: Text(
                      "معسلات",
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "مشروبات",
                    child: Text(
                      "مشروبات",
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "المطعم",
                    child: Text(
                      "المطعم",
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    section = value;
                  });
                },
                value: section,
                elevation: 2,
                isDense: true,
                iconSize: 40.0,
                hint: Text(
                  "أختر القسم",
                  style: TextStyle(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Builder(
                builder: (BuildContext context) {
                  return RaisedButton(
                      child: Text(
                        "إظافة",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      color: Colors.pink[400],
                      onPressed: () async {
                        if (orderName == null || orderName=='') {
                          msgErr = 'أكتب أسم الطلب';
                        } else if (orderPrice == null || orderPrice=='') {
                          msgErr = 'أكتب سعر الطلب';
                        } else if (section == null ) {
                          msgErr = 'أختر قسم الطلب';
                        } else {
                          msgErr = null;
                          await Firestore.instance
                              .collection('order')
                              .document()
                              .setData({
                            'cafename': widget.cafeName,
                            'order': orderName,
                            'price': orderPrice,
                            'section': section,
                          });
                           SnackBar mySnackBar = SnackBar(
                            content: Text(
                              "تم بنجاح",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 24),
                            ),
                            backgroundColor: Colors.green,
                            duration: const Duration(milliseconds: 500),
                          );
                          Scaffold.of(context).showSnackBar(mySnackBar);
                        }
                        if (msgErr != null) {
                          SnackBar mySnackBar = SnackBar(
                            content: Text(
                              msgErr,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 24),
                            ),
                            backgroundColor: Colors.red,
                            duration: const Duration(milliseconds: 500),
                          );
                          Scaffold.of(context).showSnackBar(mySnackBar);
                        }
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
