import 'package:agro_shopping/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void addData(ProductData product) async {
  // var products = await FirebaseFirestore.instance.collection('Mijan');
  final crops = await FirebaseFirestore.instance.collection('crops');
  // dummyProducts.forEach((product) {
  // products.add(product.toJson());
  // });
  // dummyCrops.forEach((crop) {
  //   crops.add(crop.toJson());
  // });
}
