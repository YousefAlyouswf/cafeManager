import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSeats extends StatefulWidget {
  final String cafeName;

  const AddSeats({Key key, this.cafeName}) : super(key: key);
  @override
  _AddSeatsState createState() => _AddSeatsState();
}

class _AddSeatsState extends State<AddSeats> {
  String seatNum;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("إدارة مقهى ${widget.cafeName}"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Text("Add seats"),
          TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (val) {
              setState(() {
                seatNum = val;
              });
            },
          ),
          RaisedButton(
            onPressed: () {
              Firestore.instance
                  .collection('seats')
                  .document(widget.cafeName)
                  .updateData({
                'allseats': FieldValue.arrayUnion([
                  {
                    'seat': seatNum,
                    'color': 'green',
                    'userid': '',
                    'username': '',
                    'userphone': '',
                    'time': '',
                  }
                ]),
              });
            },
            child: Text("A D D"),
          )
        ],
      ),
    );
  }
}
