import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/seats_models.dart';
import 'package:flutter/material.dart';

class AllSeats extends StatefulWidget {
  final String cafeName;
  final String phone;
  const AllSeats({Key key, this.cafeName, this.phone}) : super(key: key);
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
              List<SeatsModels> seatsModels = new List();
              for (var i = 0; i < snapshot.data['allseats'].length; i++) {
                if (snapshot.data['allseats'][i]['worker'] == widget.phone) {
                  seatsModels.add(SeatsModels(
                    snapshot.data['allseats'][i]['color'].toString(),
                    int.parse(snapshot.data['allseats'][i]['seat']),
                    snapshot.data['allseats'][i]['userid'],
                    snapshot.data['allseats'][i]['username'],
                    snapshot.data['allseats'][i]['userphone'],
                    snapshot.data['allseats'][i]['time'],
                    snapshot.data['allseats'][i]['worker'],
                  ));
                }
              }
              seatsModels.sort((a, b) {
                var r = a.seat.compareTo(b.seat);

                return r;
              });
              return GridView.builder(
                itemCount: seatsModels.length,
                itemBuilder: (context, index) {
                  Color color;
                  bool isbooked = false;
                  if (seatsModels[index].color.toString() == 'green') {
                    color = Colors.green;
                    isbooked = true;
                  } else {
                    color = Colors.grey;
                    isbooked = false;
                  }
                  String idSeat = snapshot.data['allseats'][index].toString();
                  String seatNum = seatsModels[index].seat.toString();
                  String userid = seatsModels[index].userID.toString();
                  String username = seatsModels[index].userName.toString();
                  String userphone = seatsModels[index].userPhone.toString();
                  String time = seatsModels[index].time.toString();
                  return InkWell(
                    onTap: isbooked
                        ? null
                        : () async {
                            showBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                      color: Colors.black12,
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: Padding(
                                        padding: const EdgeInsets.all(32.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Seat: " + seatNum,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Name: " + username,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Phone: " + userphone,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Time: " + time,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 24),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            IconButton(
                                                icon: Icon(
                                                  Icons.delete,
                                                  size: 48,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  await Firestore.instance
                                                      .collection('seats')
                                                      .document(widget.cafeName)
                                                      .updateData({
                                                    'allseats':
                                                        FieldValue.arrayRemove([
                                                      {
                                                        'seat': seatNum,
                                                        'color': 'grey',
                                                        'userid': userid,
                                                        'username': username,
                                                        'userphone': userphone,
                                                        'time': time,
                                                        'worker': widget.phone,
                                                      }
                                                    ]),
                                                  });
                                                  await Firestore.instance
                                                      .collection('seats')
                                                      .document(widget.cafeName)
                                                      .updateData({
                                                    'allseats':
                                                        FieldValue.arrayUnion([
                                                      {
                                                        'seat': seatNum,
                                                        'color': 'green',
                                                        'userid': '',
                                                        'username': '',
                                                        'userphone': '',
                                                        'time': '',
                                                        'worker': widget.phone,
                                                      }
                                                    ]),
                                                  });
                                                  await Firestore.instance
                                                      .collection('users')
                                                      .document(userid)
                                                      .updateData({
                                                    'booked': '',
                                                    'cafename': '',
                                                    'seatid': '',
                                                  });

                                                  final QuerySnapshot result =
                                                      await Firestore.instance
                                                          .collection('faham')
                                                          .getDocuments();
                                                  final List<DocumentSnapshot>
                                                      documents =
                                                      result.documents;
                                                  documents.forEach((data) {
                                                    String cafeNameOrder =
                                                        data['cafename'];
                                                    String seatOrder =
                                                        data['seatnum'];
                                                    if (cafeNameOrder ==
                                                            widget.cafeName &&
                                                        seatOrder == seatNum) {
                                                      Firestore.instance
                                                          .collection('faham')
                                                          .document(
                                                              data.documentID)
                                                          .delete();
                                                    }
                                                  });
                                                  Navigator.pop(context);
                                                })
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                    splashColor: Colors.purple,
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Center(
                        child: Text(
                          seatsModels[index].seat.toString(),
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
