import 'dart:math';
import 'package:ai_app/user_auth/firebase_auth_implementatio/firebase_auth_services.dart';
import 'package:ai_app/views/pages/ecom/orderpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ai_app/models/product.dart';
import 'package:ai_app/views/pages/ecom/product_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:ai_app/views/pages/ecom/cart_model.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('My Cart', style: TextStyle(color: Colors.black)),
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: MediaQuery.of(context).size.height * 0.53,
                  child: cart.items.isNotEmpty
                      ? ListView.builder(
                          itemCount: cart.itemCount,
                          itemBuilder: (context, index) {
                            final product = cart.items[index];
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              secondaryActions: [
                                MaterialButton(
                                  color: Colors.red.withOpacity(0.15),
                                  elevation: 0,
                                  height: 60,
                                  minWidth: 60,
                                  shape: CircleBorder(),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    cart.removeFromCart(product);
                                  },
                                ),
                              ],
                              child: cartItem(product, cart),
                            );
                          },
                        )
                      : Center(
                          child: Text('No items in the cart'),
                        ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Shipping',
                          style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 255, 255, 255))),
                      Text('\₹5.99',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 252, 252, 252)))
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: DottedBorder(
                    color: Colors.grey,
                    dashPattern: [10, 10],
                    padding: EdgeInsets.all(0),
                    child: Container(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Total',
                          style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 255, 255, 255))),
                      Text('\₹${(cart.totalPrice + 5.99).toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 255, 255, 255)))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: MaterialButton(
                    onPressed: () {
                      var options = {
                        'key': 'rzp_test_MM56UJriFCTJWs',
                        'amount':
                            ((cart.totalPrice + 5.99) * 100).toInt().toString(),
                        'name': 'Megan.Ai',
                        'description': 'Fine T-Shirt',
                        'prefill': {
                          'contact': '8888888888',
                          'email': 'info@meganai.com'
                        }
                      };
                      _razorpay.open(options);
                    },
                    height: 50,
                    elevation: 0,
                    splashColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.yellow[800],
                    child: Center(
                      child: Text(
                        "Checkout",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget cartItem(Product product, CartModel cart) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductViewPage(product: product)));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.imageURL,
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
          ),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.brand,
                    style: TextStyle(
                      color: Colors.orange.shade400,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '\₹${product.price}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                ]),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(
                minWidth: 10,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  cart.removeFromCart(product);
                },
                shape: CircleBorder(),
                child: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.grey.shade400,
                  size: 30,
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    cart.getItemCount(product).toString(),
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  ),
                ),
              ),
              MaterialButton(
                padding: EdgeInsets.all(0),
                minWidth: 10,
                splashColor: Colors.yellow[700],
                onPressed: () {
                  cart.addToCart(product);
                },
                shape: CircleBorder(),
                child: Icon(
                  Icons.add_circle,
                  size: 30,
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: "Payment success");
    final cart = Provider.of<CartModel>(context, listen: false);
    List<Product> orderedProducts = cart.items.toList();

    // Save order details to Firebase
    await _saveOrderToFirebase(orderedProducts, cart.totalPrice + 5.99);

    cart.clearCart(); // Clear the cart after successful payment
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderPage()),
    );
  }

  Future<void> _saveOrderToFirebase(
      List<Product> products, double totalAmount) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final firestore = FirebaseFirestore.instance;

      // Generate a random order ID
      final String orderId =
          '${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(9999)}';

      final orderData = {
        'orderId': orderId, // Include the order ID in the order data
        'userId': user.uid,
        'products': products
            .map((product) => {
                  'name': product.name,
                  'brand': product.brand,
                  'price': product.price,
                  'imageURL': product.imageURL,
                  'quantity': Provider.of<CartModel>(context, listen: false)
                      .getItemCount(product),
                })
            .toList(),
        'totalAmount': totalAmount,
        'orderDate': DateTime.now(),
        'status': 'pending', // You can add more fields as necessary
      };

      await firestore.collection('orders').add(orderData);
    } else {
      // Handle the case when the user is not authenticated
      Fluttertoast.showToast(msg: "User not authenticated");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed");
    // Add more error handling here if needed
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "External Wallet: ${response.walletName}");
    // Handle external wallet selection
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}
