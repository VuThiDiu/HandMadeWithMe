import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/login_reg_pages/loading.dart';
import 'package:first_app/models/OrderDetail.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:first_app/my_orders/review_dialog.dart';
import 'package:first_app/my_orders/my_orders_detail.dart';
import 'package:flutter/rendering.dart';
import 'package:first_app/my_orders/product_short.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends StatefulWidget {
  User user;
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();

  MyOrdersScreen({this.user});
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<OrderDetail> listOrdered = new List();
  bool viewResult = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int count = 0;
    List<OrderDetail> result = new List();

    PurchaseService().getAllOrders(widget.user.uid).then((QuerySnapshot value) {
      count = value.documents.length;
      if (value.documents.isNotEmpty) {
        value.documents.forEach((element) {
          result.add(OrderDetail.fromJson(element.data));
        });
        if (result.length == count) {
          setState(() {
            this.listOrdered = result;
            this.viewResult = true;
          });
        }
      } else {
        setState(() {
          this.listOrdered = [];
          this.viewResult = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return this.viewResult
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Color(4294945450),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              title: Text(
                'Sản phẩm đã mua',
                style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              centerTitle: true,
            ),
            body: Container(
              color: Colors.blueGrey[50],
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                itemCount: listOrdered.length,
                itemBuilder: (context, index) {
                  return _buildOrdersItem(listOrdered[index]);
                },
                separatorBuilder: (context, index) => SizedBox(height: 16),
              ),
            ),
          )
        : Loading();
  }

  Widget _buildOrdersItem(OrderDetail order) {
    return Column(children: [
          Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 8,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MyOrderDetail(widget.user, order)));
                },
                child: ProductShort(order),
              )),
          Row(children: [
            SizedBox(
              width: 200
            ),
            Container(
              width: 190,
              padding: EdgeInsets.symmetric(
                horizontal: 1,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                color: Color(4294565598),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ReviewDialog(order, widget.user)));
                },
                child: Text(
                  'Đánh giá sản phẩm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ]),
        ]);
  }
}
