import 'package:agro_shopping/resource/remote/fire_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // user can update their profile here, name, mobile number, address, etc.

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: userRef.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found'));
            }
            final user = snapshot.data?.data();
            final name = user?['name'] ?? '';
            final email = user?['email'] ?? '';
            final photoUrl = user?['photoUrl'] ?? '';
            final address = user?['address'] ?? '';
            final phone = user?['phone'] ?? '';
            final isSeller = user?['isSeller'] ?? false;
            nameController.text = name;
            addressController.text = address;
            phoneController.text = phone;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(photoUrl),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isSeller ? 'Seller' : 'Buyer',
                    style: TextStyle(
                      fontSize: 18,
                      color: isSeller ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      userRef.update({
                        'name': nameController.text,
                        'address': addressController.text,
                        'phone': phoneController.text,
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
