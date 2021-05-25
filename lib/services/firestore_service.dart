import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({String path, Map<String, dynamic> data}) async {
    final documentReference = FirebaseFirestore.instance.doc(path);
    await documentReference.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map(
          (snapshot) => builder(snapshot.data()),
    ).toList());
  }
}