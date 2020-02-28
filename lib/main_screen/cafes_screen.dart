import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CafesScreen extends StatefulWidget {
  @override
  _CafesScreenState createState() => _CafesScreenState();
}

class _CafesScreenState extends State<CafesScreen> {
  String seatNum;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إدارة المقهى"),
      ),
      body: Column(
        children: <Widget>[
          Text("Add seats"),

          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (val){
              setState(() {
                seatNum = val;
              });
            },
          ),
          RaisedButton(onPressed: (){
 Firestore.instance.collection('seats').document('العرب').updateData({
      'allseats': FieldValue.arrayUnion([
        {
          'seat': seatNum,
          'color': 'green',
          'userid': '',
          'username': '',
          'userphone': '',
        }
      ]),
    });
          }, child: Text("A D D"),)
        ],
      ),
    );
  }
}
