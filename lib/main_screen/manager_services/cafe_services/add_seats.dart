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
  String user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text("أظافة جلسات"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'رقم الجلسة',
                  suffixIcon: Icon(
                    Icons.event_seat,
                  ),
                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                ),
                onChanged: (val) {
                  setState(() {
                    seatNum = val;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: Firestore.instance
                      .collection('manager')
                      .where('cafe', isEqualTo: widget.cafeName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading...');
                    } else {
                      List<DropdownMenuItem> users = [];
                      for (var i = 0; i < snapshot.data.documents.length; i++) {
                        users.add(
                          DropdownMenuItem(
                            child: Text(
                              snapshot.data.documents[i]['name'] +
                                  " => " +
                                  snapshot.data.documents[i]['phone'],
                              textDirection: TextDirection.rtl,
                            ),
                            value: snapshot.data.documents[i]['phone'],
                          ),
                        );
                      }
                      return DropdownButton(
                        items: users,
                        onChanged: (value) {
                          setState(() {
                            user = value;
                          });
                        },
                        value: user,
                        elevation: 2,
                        isDense: true,
                        iconSize: 40.0,
                        hint: Text(
                          "أختر أسم الموظف",
                          style: TextStyle(),
                        ),
                      );
                    }
                  }),
              SizedBox(
                height: 40,
              ),
              Builder(
                builder: (BuildContext context) {
                  return RaisedButton(
                    onPressed: () async {
                      if (seatNum == null || seatNum == '') {
                        msgErr = 'أكتب رقم الجلسة';
                      } else {
                        msgErr = null;
                        String workerName;
                        final QuerySnapshot result = await Firestore.instance
                            .collection('manager')
                            .getDocuments();
                        final List<DocumentSnapshot> documents =
                            result.documents;
                        documents.forEach((data) {
                          if (user == data['phone']) {
                            workerName = data['name'];
                          }
                        });

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
                              'worker': user,
                              'workerName': workerName
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
                    color: Colors.green[400],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
