import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:provider/provider.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:ai_app/views/pages/ecom/cart.dart';
import 'package:ai_app/views/pages/ecom/cart_model.dart';
import 'package:ai_app/views/pages/ecom/explore.dart';
import 'package:ai_app/views/pages/ecom/orderpage.dart';

class EcomPage extends StatefulWidget {
  const EcomPage({Key? key}) : super(key: key);

  @override
  _EcomPageState createState() => _EcomPageState();
}

class _EcomPageState extends State<EcomPage> {
  late PageController _pageController;
  int _selectedPage = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartModel(),
      child: Scaffold(
        body: PageView(
          onPageChanged: (index) => setState(() {
            _selectedPage = index;
          }),
          controller: _pageController,
          children: [
            ExplorePage(),
            CartPage(),
            OrderPage(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(3, 0), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
              child: FlashyTabBar(
                backgroundColor: Color.fromARGB(255, 9, 9, 9),
                selectedIndex: _selectedPage,
                showElevation: false,
                onItemSelected: (index) {
                  setState(() {
                    _selectedPage = index;
                    _pageController.jumpToPage(index);
                  });
                },
                items: [
                  FlashyTabBarItem(
                    activeColor: Colors.white,
                    icon: Icon(Icons.home_outlined, size: 23),
                    title: Text('Home'),
                  ),
                  FlashyTabBarItem(
                    activeColor: Colors.white,
                    icon: Icon(Icons.shopping_bag_outlined, size: 23),
                    title: Text('Cart'),
                  ),
                  FlashyTabBarItem(
                    activeColor: Colors.white,
                    icon: Icon(Icons.receipt, size: 23),
                    title: Text('Order'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
