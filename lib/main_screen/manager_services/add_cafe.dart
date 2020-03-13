import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddCafe extends StatefulWidget {
  @override
  _AddCafeState createState() => _AddCafeState();
}

class _AddCafeState extends State<AddCafe> {
  String cafeName;
  String lat;
  String long;
  String city;
  File _image;
  bool isSuccess = false;
  String url;
  String managerName;
  String password;
  String phone;
  String branch;

  final CollectionReference collectionReference =
      Firestore.instance.collection('cafes');
  final CollectionReference collectionReferenceAddManager =
      Firestore.instance.collection('manager');
  final CollectionReference collectionReferenceAddSeat =
      Firestore.instance.collection('seats');

  Future updateSection(String name, String image) async {
    await collectionReference.document().setData({
      'name': name,
      'image': image,
      'stars': '5',
      'reviewcount': '1',
      'lat': lat,
      'long': long,
      'city': city,
      'branch': branch,
    });
  }

  Future addManager(
      String name, String managerName, String password, String phone) async {
        
    await collectionReferenceAddManager.document().setData({
      'cafe': name,
      'name': managerName,
      'password': password,
      'phone': phone,
      'pushToken': ''
    });
  }

  Future addSeats() async {
    collectionReferenceAddSeat.document(cafeName).setData({
      'code': '1',
      'password': '1',
    });
  }

  Future uploadImage() async {
    String fileName = '${DateTime.now()}.png';
    StorageReference firebaseStorage =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorage.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    url = await firebaseStorage.getDownloadURL() as String;

    if (url.isNotEmpty) {
      updateSection(cafeName, url);
      addManager(cafeName, managerName, password, phone);
      addSeats();

      // firestoreService.UpdateSection(sectionName, url);
      // Fluttertoast.showToast(
      //     msg: "تمت أظافة القسم",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIos: 1,
      //     backgroundColor: Colors.green[200],
      //     textColor: Colors.white,
      //     fontSize: 16.0);

    }
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        centerTitle: true,
        title: Text("الإدارة العامة"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 50,
                        child: ClipOval(
                          child: SizedBox(
                            height: 180,
                            width: 180,
                            child: (_image != null)
                                ? Image.file(_image, fit: BoxFit.fill)
                                : Image.network(
                                    'https://t4.ftcdn.net/jpg/02/57/34/73/240_F_257347345_xMLYoln5APOlAJcmv8x0FPexLUeRMdzA.jpg',
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 18),
                      child: IconButton(
                        iconSize: 50,
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.image),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        cafeName = val;
                      });
                    },
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'أسم المقهى',
                      suffixIcon: Icon(Icons.local_cafe),
                      hintStyle:
                          TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        branch = val;
                      });
                    },
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'فرع المقهى',
                      suffixIcon: Icon(Icons.local_convenience_store),
                      hintStyle:
                          TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        city = val;
                      });
                    },
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'المدينة ',
                      suffixIcon: Icon(Icons.location_city),
                      hintStyle:
                          TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        lat = val;
                      });
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'موقع المقهى LAT',
                      suffixIcon: Icon(Icons.location_on),
                      hintStyle:
                          TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        long = val;
                      });
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'موقع المقهى LONG',
                      suffixIcon: Icon(Icons.location_on),
                      hintStyle:
                          TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black,
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        managerName = val;
                      });
                    },
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'أسم المدير',
                      suffixIcon: Icon(Icons.person),
                      hintStyle:
                          TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        phone = val;
                      });
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'رقم الجوال',
                      suffixIcon: Icon(Icons.phone_iphone),
                      hintStyle:
                          TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.end,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'كلمة المرور',
                      suffixIcon: Icon(Icons.lock),
                      hintStyle:
                          TextStyle(color: Colors.grey, fontFamily: 'topaz'),
                    ),
                  ),
                ),
                RaisedButton(
                    child: Text(
                      "إنشاء",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                    ),
                    color: Colors.green[400],
                    onPressed: () async {
                      uploadImage();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
