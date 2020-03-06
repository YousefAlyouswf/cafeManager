import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Services extends StatefulWidget {
  final String cafeName;
  final String phone;
  const Services({Key key, this.cafeName, this.phone}) : super(key: key);
  @override
  _ServicesState createState() => _ServicesState();
}

class _ServicesState extends State<Services> {




 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الخدمات"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('faham')
              // .where('cafename', isEqualTo: widget.cafeName)
              .orderBy('sort')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("");
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
           
                  DocumentSnapshot service = snapshot.data.documents[index];
                  return service['cafename'] == widget.cafeName &&
                          service['worker'] == widget.phone
                      ? Card(
                          child: ListTile(
                            trailing: Text(
                              "جلسة رقم: " + service['seatnum'],
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 24),
                            ),
                            onLongPress: () {
                              Firestore.instance
                                  .collection('faham')
                                  .document(service.documentID)
                                  .delete();
                            },
                          ),
                        )
                      : null;
                },
              );
            }
          },
        ),
      ),
    );
  }
}
