import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeleteAcount extends StatelessWidget {
  final String cafeName;

  const DeleteAcount({Key key, this.cafeName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("حذف حساب"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('manager')
              .where('cafe', isEqualTo: cafeName)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("");
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot service = snapshot.data.documents[index];

                  return InkWell(
                    onTap: () async {
                      showBottomSheet(
                          context: context,
                          builder: (context) => Container(
                                color: Colors.black12,
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          service['name'],
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          service['phone'],
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          service['password'],
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.delete_forever,
                                            size: 40,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            Firestore.instance
                                                .collection('manager')
                                                .document(service.documentID)
                                                .delete();
                                            Navigator.of(context).pop();
                                          })
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("الاسم "+
                                  service['name'],
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
                                child: Text("الجوال "+
                                  service['phone'],
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
}
