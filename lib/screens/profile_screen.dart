import 'package:agro_shopping/resource/remote/fire_data.dart';
import 'package:agro_shopping/screens/login_screen.dart';
import 'package:agro_shopping/screens/products_list.dart';
import 'package:agro_shopping/screens/profile_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      body: StreamBuilder(
          stream: userRef.snapshots(),
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
            return Center(
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
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isSeller) const SizedBox(height: 10),
                  if (isSeller)
                    const Text(
                      'Seller',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(
                    [
                      if (email.isNotEmpty) email,
                      if (address.isNotEmpty) address,
                      if (phone.isNotEmpty) phone,
                    ].join('\n'),
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileSettingsScreen(),
                        ),
                      );
                    },
                    leading: const Icon(Icons.settings),
                    title: const Text('Profile Settings'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ItemListScreen(
                            'My Posts',
                            productsRef
                                .where('uid', isEqualTo: uid)
                                .snapshots(),
                            enableAppBar: true,
                          ),
                        ),
                      );
                    },
                    leading: const Icon(Icons.library_books_rounded),
                    title: const Text('My Posts'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  ListTile(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    leading: const Icon(Icons.logout_outlined),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    title: const Text('Logout'),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
