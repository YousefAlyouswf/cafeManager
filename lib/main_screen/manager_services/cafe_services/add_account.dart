import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddAccount extends StatefulWidget {
  final String cafeName;

  const AddAccount({Key key, this.cafeName}) : super(key: key);
  @override
  _AddAcountState createState() => _AddAcountState();
}

class _AddAcountState extends State<AddAccount> {
  String name;
  String phone;
  String password;

  String errMsg;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        title: Text("إظافة طلبات"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'أسم الموظف',
                  suffixIcon: Icon(Icons.person),
                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'رقم الجوال',
                  suffixIcon: Icon(Icons.phone_android),
                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                ),
                onChanged: (val) {
                  setState(() {
                    phone = val;
                  });
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'كلمة المرور',
                  suffixIcon: Icon(Icons.lock_outline),
                  hintStyle: TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                ),
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Builder(
                builder: (BuildContext context) {
                  return RaisedButton(
                    child: Text(
                      "إظافة",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    color: Colors.green[400],
                    onPressed: () async {
                      final QuerySnapshot result = await Firestore.instance
                          .collection('manager')
                          .getDocuments();
                      final List<DocumentSnapshot> documents = result.documents;
                      documents.forEach((data) {
                        if (data['phone'] == phone) {
                          errMsg = 'رقم الجوال مسجل من قبل';
                        }
                      });
                      if (errMsg == null) {
                        await Firestore.instance.collection("manager").add({
                          'name': name,
                          'cafe': widget.cafeName,
                          'password': password,
                          'phone': phone,
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
                      } else {
                        SnackBar mySnackBar = SnackBar(
                          content: Text(
                            errMsg,
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 24),
                          ),
                          backgroundColor: Colors.red,
                          duration: const Duration(milliseconds: 1500),
                        );
                        Scaffold.of(context).showSnackBar(mySnackBar);
                      }
                    },
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
