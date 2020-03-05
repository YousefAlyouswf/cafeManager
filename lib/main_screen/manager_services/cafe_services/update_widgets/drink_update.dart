import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'firestore_order.dart';

class DrinkUdate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirestoreOrder('مشروبات');
  }
}
