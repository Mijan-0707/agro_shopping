import 'package:agro_shopping/model/product.dart';
import 'package:agro_shopping/resource/remote/fire_data.dart';
import 'package:agro_shopping/screens/create_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    super.key,
    required this.data,
    this.isCrops = false,
  });

  final ProductData data;
  final bool isCrops;

  @override
  Widget build(BuildContext context) {
    final collection = isCrops ? cropsRef : productsRef;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          FutureBuilder(
              future: collection.doc(data.id).get(),
              builder: (context, snapshot) {
                final isOwner = snapshot.data?.data()?.uid ==
                    FirebaseAuth.instance.currentUser?.uid;
                if (!isOwner) return const SizedBox();
                return PopupMenuButton(
                  itemBuilder: (c) {
                    return {'Edit', 'Delete'}.map((String choice) {
                      return PopupMenuItem(
                          onTap: () async {
                            if (choice == 'Edit') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CreateProductScreen.update(
                                    data: data,
                                    isCrops: isCrops,
                                  ),
                                ),
                              );
                            } else if (choice == 'Delete') {
                              collection.doc(data.id).delete();
                              Navigator.pop(context);
                            }
                          },
                          value: choice,
                          child: Text(choice));
                    }).toList();
                  },
                );
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: collection.doc(data.id).snapshots(),
          builder: (context, snapshot) {
            final data = snapshot.data?.data();
            print([data]);
            if (!snapshot.hasData || data == null) {
              return const Text('Loading...');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(data.image ?? '',
                    height: 250, width: double.infinity, fit: BoxFit.cover),
                const SizedBox(height: 16),
                Text(data.title!,
                    style: Theme.of(context).textTheme.titleLarge),
                Text(data.category!),
                Text(data.description!),
                Text(
                    'Price: ${data.price ?? 0} per ${data.quantityType ?? ''}'),
                Text('Quantity: ${data.quantity ?? 0} ${data.quantityType}'),

                // seller info
                const SizedBox(height: 16),
                Text('Seller Info',
                    style: Theme.of(context).textTheme.titleLarge),
                Text(data.sellerName ?? ''),
                Text(data.sellerAddress ?? ''),

                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: data.contractNumber ?? ''),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')));
                  },
                  child: Text(data.contractNumber ?? ''),
                ),
                const Spacer(),
                ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(data.image ?? '',
                        height: 250, fit: BoxFit.fill),
                  ),
                  title: Text(data.sellerName ?? 'Info not found',
                      style: Theme.of(context).textTheme.titleLarge),
                  subtitle: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: (data.contractNumber ?? '').isEmpty
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          final url =
                                              'tel:${data.contractNumber ?? ''}';
                                          launchUrlString(url);
                                        },
                                        child: const Text('Call'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final url = Uri.parse(
                                              'https://wa.me/${data.contractNumber ?? ''}');
                                          launchUrl(url);
                                        },
                                        child: const Text('WhatsApp'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                    child: const Text('Call'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
