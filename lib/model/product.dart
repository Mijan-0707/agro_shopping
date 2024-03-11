import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  final String? title,
      category,
      description,
      image,
      price,
      quantityType,
      sellerName,
      sellerAddress,
      contractNumber;
  String? id, uid;
  final int? quantity;

  ProductData({
    this.title,
    this.category,
    this.description,
    this.image,
    this.price,
    this.quantity,
    this.id,
    this.uid,
    this.quantityType,
    this.sellerName,
    this.sellerAddress,
    this.contractNumber,
  });

  factory ProductData.fromJson(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ProductData(
        id: snapshot.id,
        uid: data?['uid'],
        title: data?['title'],
        category: data?['category'],
        description: data?['description'],
        image: data?['image'],
        price: data?['price'],
        quantity: data?['quantity'],
        quantityType: data?['quantityType'],
        sellerName: data?['sellerName'],
        sellerAddress: data?['sellerAddress'],
        contractNumber: data?['contractNumber']);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'category': category,
        'description': description,
        'image': image,
        'price': price,
        'quantity': quantity,
        'quantityType': quantityType,
        'sellerName': sellerName,
        'sellerAddress': sellerAddress,
        'contractNumber': contractNumber
      };
}
