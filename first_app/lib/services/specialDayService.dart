import 'package:cloud_firestore/cloud_firestore.dart';

class specilaDayService{
  getSpecialDay()  {
    return   Firestore.instance
        .collection("specialDay")
        .getDocuments();
  }
}