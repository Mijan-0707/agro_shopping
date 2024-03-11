import 'package:agro_shopping/resource/remote/fire_data.dart';
import 'package:agro_shopping/screens/create_product.dart';
import 'package:agro_shopping/screens/products_list.dart';
import 'package:agro_shopping/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class NavigationWrapper extends StatefulWidget {
  const NavigationWrapper({super.key});

  @override
  State<NavigationWrapper> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<NavigationWrapper> {
  final _screens = <Widget>[
    const HomeScreen(),
    ItemListScreen('Buy', productsRef.snapshots()),
    ItemListScreen('Sell', cropsRef.snapshots(), isCrops: true),
    const ProfileScreen()
  ];
  final labels = ['Home', 'Products', 'Crops', 'Profile'];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(labels[_selectedIndex]),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateProductScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Home',
            activeIcon: Icon(Icons.home_filled),
            icon: Icon(Icons.home_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Products',
            activeIcon: Icon(Icons.local_grocery_store),
            icon: Icon(Icons.local_grocery_store_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Crops',
            activeIcon: Icon(Icons.eco),
            icon: Icon(Icons.eco_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            activeIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _screens[_selectedIndex],
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset('assets/logo.png'),
    );
  }
}
