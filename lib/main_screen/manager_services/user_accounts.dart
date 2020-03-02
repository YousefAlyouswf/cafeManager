import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersAccounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("حسابات المستخدمين"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
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
                          snapshot.data.documents[index].data['phone'],
                          textAlign: TextAlign.end,
                        ),
                        onTap: () {
                          showBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                    color: Colors.black54,
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(32.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Name: " +
                                                snapshot.data.documents[index]
                                                    .data['name'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Phone: " +
                                                snapshot.data.documents[index]
                                                    .data['phone'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Password: " +
                                                snapshot.data.documents[index]
                                                    .data['password'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
                        },
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
      ),
    );
  }
}
