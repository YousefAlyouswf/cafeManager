import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreOrder extends StatefulWidget {
  String section;
  FirestoreOrder(this.section);

  @override
  _FirestoreOrderState createState() => _FirestoreOrderState();
}

class _FirestoreOrderState extends State<FirestoreOrder> {
  String orderName;
  String orderPrice;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('order')
            .where('section', isEqualTo: widget.section)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("");
          } else {
            return GridView.builder(
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
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "الطلب " + service['order'],
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "السعر " + service['price'] + " ريال ",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.delete_forever,
                                          size: 40,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          Firestore.instance
                                              .collection('order')
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
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text(
                              service['order'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              service['price'] + " ريال",
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
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
            );
          }
        },
      ),
    );
  }
}
