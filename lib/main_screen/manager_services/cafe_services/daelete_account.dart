import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_manager/models/worker_seats.dart';
import 'package:flutter/material.dart';

class DeleteAcount extends StatefulWidget {
  final String cafeName;

  DeleteAcount({
    Key key,
    this.cafeName,
  }) : super(key: key);

  @override
  _DeleteAcountState createState() => _DeleteAcountState();
}

class _DeleteAcountState extends State<DeleteAcount> {
  List<WorkerSeats> seatsList = new List();

  void seats() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('seats').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      if (data.documentID == widget.cafeName) {
        for (var i = 0; i < data['allseats'].length; i++) {
          seatsList.add(WorkerSeats(
              data['allseats'][i]['seat'], data['allseats'][i]['worker']));
        }
      }
    });
  }

  @override
  void initState() {
    seats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        centerTitle: true,
        title: Text("معلومات الموظفين"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('manager')
              .where('cafe', isEqualTo: widget.cafeName)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("");
            } else {
              print(seatsList);
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot service = snapshot.data.documents[index];

                  return InkWell(
                    onTap: () async {
                      List<int> seatThisWorker = new List();
                      for (var i = 0; i < seatsList.length; i++) {
                        if (seatsList[i].phone == service['phone']) {
                          seatThisWorker.add(int.parse(seatsList[i].seat));
                        }
                      }
                      seatThisWorker.sort();

                      showBottomSheet(
                          context: context,
                          builder: (context) => Container(
                                color: Colors.red[100],
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "الأسم " + service['name'],
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "الجوال " + service['phone'],
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "كلمة المرور " + service['password'],
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "الجلسات",
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Expanded(
                                        child: GridView.builder(
                                          itemCount: seatThisWorker.length,
                                          itemBuilder: (context, index) {
                                            return Text(seatThisWorker[index]
                                                .toString());
                                          },
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 10,
                                            childAspectRatio: 3 / 2,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.delete_forever,
                                              size: 40,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              _showDialog(
                                                service.documentID,
                                                seatThisWorker.length,
                                                seatThisWorker,
                                                service['phone'],
                                                service['name'],
                                              );
                                            }),
                                      )
                                    ],
                                  ),
                                ),
                              ));
                    },
                    splashColor: Colors.purple,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.green[100],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "الاسم " + service['name'],
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "الجوال " + service['phone'],
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void _showDialog(
      String id, int list, List seatNum, String worker, String workerName) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Center(child: new Text("تأكيد")),
          content: new Text(
            "هل تريد حذف معلومات الموظف فقط أو حذف الجلسات بأسم الموظف",
            textDirection: TextDirection.rtl,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("حذف الجلسات"),
              onPressed: () {
                Firestore.instance.collection('manager').document(id).delete();

                for (var i = 0; i < list; i++) {
                  Firestore.instance
                      .collection('seats')
                      .document(widget.cafeName)
                      .updateData({
                    'allseats': FieldValue.arrayRemove([
                      {
                        'seat': seatNum[i].toString(),
                        'color': 'green',
                        'userid': '',
                        'username': '',
                        'userphone': '',
                        'time': '',
                        'worker': worker,
                        'workerName': workerName,
                      }
                    ]),
                  });
                }

                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("حذف الموظف فقط"),
              onPressed: () {
                Firestore.instance.collection('manager').document(id).delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
