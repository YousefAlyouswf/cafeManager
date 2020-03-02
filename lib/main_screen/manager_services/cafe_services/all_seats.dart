import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllSeats extends StatefulWidget {
  final String cafeName;

  const AllSeats({Key key, this.cafeName}) : super(key: key);
  @override
  _AllSeatsState createState() => _AllSeatsState();
}

class _AllSeatsState extends State<AllSeats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الجلسات"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('seats')
              .document(widget.cafeName)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("");
            } else {
              return GridView.builder(
                itemCount: snapshot.data['allseats'].length,
                itemBuilder: (context, index) {
                  Color color;
                  bool isbooked = false;
                  if (snapshot.data['allseats'][index]['color'] == 'green') {
                    color = Colors.green;
                    isbooked = true;
                  } else {
                    color = Colors.grey;
                    isbooked = false;
                  }
                  String idSeat = snapshot.data['allseats'][index].toString();
                  String seatNum =
                      snapshot.data['allseats'][index]['seat'].toString();
                  String userid =
                      snapshot.data['allseats'][index]['userid'].toString();
                  String username =
                      snapshot.data['allseats'][index]['username'].toString();
                  String userphone =
                      snapshot.data['allseats'][index]['userphone'].toString();
                  return InkWell(
                    onTap: isbooked
                        ? null
                        : () async {
                            Firestore.instance
                                .collection('seats')
                                .document(widget.cafeName)
                                .updateData({
                              'allseats': FieldValue.arrayRemove([
                                {
                                  'seat': seatNum,
                                  'color': 'grey',
                                  'userid': userid,
                                  'username': username,
                                  'userphone': userphone,
                                }
                              ]),
                            });
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
                                }
                              ]),
                            });
                            Firestore.instance
                                .collection('users')
                                .document(userid)
                                .updateData({
                              'booked': '',
                              'cafename': '',
                              'seatid': '',
                            });
                          },
                    splashColor: Colors.purple,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Center(
                        child: Text(
                          snapshot.data['allseats'][index]['seat'].toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color.withOpacity(0.1), color],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
