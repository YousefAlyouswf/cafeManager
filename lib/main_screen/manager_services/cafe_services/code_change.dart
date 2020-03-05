import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CodeChange extends StatefulWidget {
  final String cafeName;

  const CodeChange({Key key, this.cafeName}) : super(key: key);
  @override
  _CodeChangeState createState() => _CodeChangeState();
}

class _CodeChangeState extends State<CodeChange> {
  String code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تغيير الرمز"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: Firestore.instance.collection('seats').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("");
              } else {
                List<String> cafeCode = new List();
                for (var i = 0; i < snapshot.data.documents.length; i++) {
                  if (snapshot.data.documents[i].documentID ==
                      widget.cafeName) {
                    cafeCode.add(snapshot.data.documents[i]['code']);
                  }
                }
                return ListView.builder(
                    itemCount: cafeCode.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Text("الرمز الحالي هو [ ${cafeCode[index]} ]", style: TextStyle(fontSize: 20),),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'أكتب الرمز الجديد',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontFamily: 'topaz'),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  code = val;
                                });
                              },
                            ),
                            Builder(
                              builder: (BuildContext context) {
                                return RaisedButton(
                                  onPressed: () async {
                                    Firestore.instance
                                        .collection('seats')
                                        .document(widget.cafeName)
                                        .updateData({
                                      'code': code,
                                    });
                                    SnackBar mySnackBar = SnackBar(
                                      content: Text(
                                        "تم بنجاح",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 24),
                                      ),
                                      backgroundColor: Colors.green,
                                      duration:
                                          const Duration(milliseconds: 500),
                                    );
                                    Scaffold.of(context)
                                        .showSnackBar(mySnackBar);
                                  },
                                  child: Text(
                                    "إظافة",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                  ),
                                  color: Colors.pink[400],
                                );
                              },
                            )
                          ],
                        ),
                      );
                    });
              }
            }),
      ),
    );
  }
}
