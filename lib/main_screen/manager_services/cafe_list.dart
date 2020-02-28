import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CafeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("عدد المقاهي"),
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('cafes')
              .orderBy('city')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("جاري تحميل قائمة المقاهي"));
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    int q = index + 1;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text(
                            snapshot.data.documents[index].data['name'],
                            textAlign: TextAlign.end,
                          ),
                          subtitle: Text(
                            snapshot.data.documents[index].data['city'],
                            textAlign: TextAlign.end,
                          ),
                          trailing: Text(q.toString()),
                          leading: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await Firestore.instance.runTransaction(
                                  (Transaction myTransaction) async {
                                await myTransaction.delete(
                                    snapshot.data.documents[index].reference);
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  });
            }
          },
        ));
  }
}
