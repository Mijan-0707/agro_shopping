import 'package:agro_shopping/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final productsCollection = FirebaseFirestore.instance.collection('products');
final usersCollection = FirebaseFirestore.instance.collection('users');
final cropsCollection = FirebaseFirestore.instance.collection('crops');
final imageCollection = FirebaseStorage.instance.ref().child('images');

final productsRef = productsCollection.withConverter(
    fromFirestore: ProductData.fromJson,
    toFirestore: (ProductData product, _) => product.toJson());

final cropsRef = cropsCollection.withConverter(
    fromFirestore: ProductData.fromJson,
    toFirestore: (ProductData product, _) => product.toJson());

DocumentReference<Map<String, dynamic>> get userRef =>
    usersCollection.doc(FirebaseAuth.instance.currentUser?.uid);