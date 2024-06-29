import 'dart:convert';

import 'package:ai_app/models/product.dart';
import 'package:ai_app/views/pages/ecom/cart.dart';
import 'package:ai_app/views/pages/ecom/cart_model.dart';
import 'package:ai_app/views/pages/ecom/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  bool _isScrolled = false;

  List<dynamic> productList = [];
  List<String> size = ["S", "M", "L", "XL"];
  List<Color> colors = [
    Colors.black,
    Colors.purple,
    Colors.orange.shade200,
    Colors.blueGrey,
    Color(0xFFFFC1D9),
  ];

  int _selectedColor = 0;
  int _selectedSize = 1;
  var selectedRange = RangeValues(150.00, 1500.00);

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
    products();
    super.initState();
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= 100.0) {
      setState(() {
        _isScrolled = true;
      });
    } else {
      setState(() {
        _isScrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(controller: _scrollController, slivers: [
      SliverAppBar(
        expandedHeight: 200.0,
        elevation: 0,
        pinned: true,
        floating: true,
        stretch: true,
        backgroundColor: const Color.fromARGB(255, 1, 1, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          titlePadding: EdgeInsets.only(left: 20, right: 30, bottom: 50),
          stretchModes: [
            StretchMode.zoomBackground,
          ],
          title: AnimatedOpacity(
            opacity: _isScrolled ? 0.0 : 1.0,
            duration: Duration(milliseconds: 500),
            child: Text("T-Shirt Shopping",
                style: TextStyle(
                  color: const Color.fromARGB(255, 253, 253, 253),
                  fontSize: 28.0,
                )),
          ),
          background: Container(
            color: Colors.black,
          ),
        ),
        bottom: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Consumer<CartModel>(
                      builder: (context, cart, child) {
                        return Text(
                          '${cart.itemCount}',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        );
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Products',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 251, 251, 251),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ]),
      ),
      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 13,
          crossAxisSpacing: 5,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return productCart(productList[index]);
          },
          childCount: productList.length,
        ),
      ),
    ]);
  }

  Future<void> products() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final data = await json.decode(response);

    setState(() {
      productList =
          data['products'].map((data) => Product.fromJson(data)).toList();
    });
  }

  Widget productCart(Product product) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductViewPage(
                        product: product,
                      )));
        },
        child: Container(
          margin: EdgeInsets.only(
            right: 10,
            left: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(5, 10),
                blurRadius: 15,
                color: const Color.fromARGB(255, 8, 8, 8),
              )
            ],
          ),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(product.imageURL,
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      right: 3,
                      bottom: 0,
                      child: MaterialButton(
                        color: Colors.black,
                        minWidth: 45,
                        height: 45,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () {
                          addToCart(product);
                        },
                        padding: EdgeInsets.all(5),
                        child: Center(
                            child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                          size: 20,
                        )),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                product.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.brand,
                    style: TextStyle(
                      color: Colors.orange.shade400,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    "\₹" + product.price.toString() + '.00',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addToCart(Product product) {
    Provider.of<CartModel>(context, listen: false).addToCart(product);
  }
}
