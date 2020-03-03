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
  String msgErr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("أظافة جلسات"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'رقم الجلسة',
                hintStyle: TextStyle(color: Colors.grey, fontFamily: 'topaz'),
              ),
              onChanged: (val) {
                setState(() {
                  seatNum = val;
                });
              },
            ),
            Builder(
              builder: (BuildContext context) {
                return RaisedButton(
                  onPressed: () async {
                    if (seatNum == null || seatNum == '') {
                      msgErr = 'أكتب رقم الجلسة';
                    } else {
                      msgErr = null;

                      await Firestore.instance
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
                  },
                  child: Text(
                    "إظافة",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                  ),
                  color: Colors.pink[400],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
