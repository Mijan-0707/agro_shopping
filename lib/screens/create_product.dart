import 'dart:io';

import 'package:agro_shopping/app/app.dart';
import 'package:agro_shopping/app/const.dart';
import 'package:agro_shopping/model/product.dart';
import 'package:agro_shopping/resource/remote/fire_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

// screen to crate new product with image and details
class CreateProductScreen extends StatefulWidget {
  final ProductData data;
  final bool isCrops;

  CreateProductScreen({super.key})
      : data = ProductData(),
        isCrops = false;

  const CreateProductScreen.update({
    super.key,
    required this.data,
    required this.isCrops,
  });

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  String? imgPath;
  int _selectedIndexForCategory = 0;
  int _selectedIndexForQuantityType = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _sellerName = TextEditingController();
  final TextEditingController _sellerAddress = TextEditingController();
  final TextEditingController _contractNumber = TextEditingController();

  bool isLoading = false;
  late final collection = widget.isCrops ? cropsCollection : productsCollection;

  @override
  void initState() {
    super.initState();
    if (widget.data.id != null) {
      _titleController.text = widget.data.title ?? '';
      _descriptionController.text = widget.data.description ?? '';
      _priceController.text = widget.data.price ?? '';
      _quantityController.text = widget.data.quantity.toString();
      _selectedIndexForCategory =
          categoryTitles.indexOf(widget.data.category ?? '');
      _selectedIndexForQuantityType =
          quantityUnit.indexOf(widget.data.quantityType ?? '');
      _sellerName.text = widget.data.sellerName ?? '';
      _sellerAddress.text = widget.data.sellerAddress ?? '';
      _contractNumber.text = widget.data.contractNumber ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Product')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _sellerName,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  labelText: 'Seller Name',
                ),
              ),
              TextField(
                controller: _sellerAddress,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  labelText: 'Seller Address',
                ),
              ),
              TextField(
                controller: _contractNumber,
                enabled: !isLoading,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Contract Number',
                ),
              ),
              const SizedBox(height: 16),
              widget.data.id != null
                  ? Image.network(widget.data.image!,
                      height: 250, width: double.infinity, fit: BoxFit.cover)
                  : imgPath != null
                      ? Image.file(
                          File(imgPath!),
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            final res = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            setState(() => imgPath = res?.path);
                            debugPrint(imgPath);
                          },
                          child: const Text('Pick Image'),
                        ),
              // title
              TextField(
                controller: _titleController,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              // category
              DropdownButtonFormField(
                value: categoryTitles[_selectedIndexForCategory],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedIndexForCategory =
                        categoryTitles.indexOf(newValue!);
                  });
                },
                items: categoryTitles.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              // description
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                enabled: !isLoading,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              // price
              TextField(
                enabled: !isLoading,
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
              ),
              // quantity
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .70,
                      child: TextField(
                        enabled: !isLoading,
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .20,
                      child: DropdownButtonFormField(
                        value: quantityUnit[_selectedIndexForQuantityType],
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedIndexForQuantityType =
                                quantityUnit.indexOf(newValue!);
                          });
                        },
                        items: quantityUnit.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              // post button
              const SizedBox(height: 16),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: upload,
                      child: Text(
                        widget.data.id == null ? 'Post' : 'Update',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> upload() async {
    setState(() => isLoading = true);
    final ref =
        imageCollection.child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(File(imgPath!));
    final res = await uploadTask.whenComplete(() => null);
    final url = await res.ref.getDownloadURL();
    final data = {
      'uid': FirebaseAuth.instance.currentUser?.uid,
      'sellerName': _sellerName.text,
      'sellerAddress': _sellerAddress.text,
      'contractNumber': _contractNumber.text,
      'title': _titleController.text,
      'category': categoryTitles[_selectedIndexForCategory],
      'description': _descriptionController.text,
      'price': _priceController.text,
      'quantity': int.parse(_quantityController.text),
      'image': url,
      'quantityType': quantityUnit[_selectedIndexForQuantityType]
    };
    if (widget.data.id == null) {
      await collection
          .add(data)
          .then((value) => Navigator.pop(context))
          .catchError((err) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(err.toString()))));
    } else {
      await collection
          .doc(widget.data.id)
          .update(data)
          .then((value) => Navigator.pop(context))
          .catchError((err) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(err.toString()))));
    }

    Future.delayed(const Duration(seconds: 1), () {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Product posted successfully')),
      );
    });
    setState(() => isLoading = false);
  }
}
