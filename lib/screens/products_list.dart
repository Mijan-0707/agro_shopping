import 'package:agro_shopping/app/const.dart';
import 'package:agro_shopping/model/product.dart';
import 'package:agro_shopping/screens/product_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen(
    this.title,
    this.items, {
    super.key,
    this.isCrops = false,
    this.enableAppBar = false,
  });

  final String title;
  final bool isCrops, enableAppBar;

  final Stream<QuerySnapshot<ProductData>> items;

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.enableAppBar ? AppBar(title: Text(widget.title)) : null,
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoryTitles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ChoiceChip(
                    label: Text(categoryTitles[index]),
                    selected: _selectedIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedIndex = selected ? index : -1;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: widget.items,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.docs
                    .where((element) =>
                        _selectedIndex == -1 ||
                        element.data().category ==
                            categoryTitles[_selectedIndex])
                    .toList();
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data.elementAt(index).data();
                    return ListTile(
                      leading: SizedBox(
                        width: 50,
                        child: Image.network(item.image!),
                      ),
                      title: Text(item.title!),
                      subtitle: Text(item.category!),
                      trailing: Text(item.price!),
                      onTap: () async {
                        item.id = data.elementAt(index).id;
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(
                                data: item, isCrops: widget.isCrops),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
