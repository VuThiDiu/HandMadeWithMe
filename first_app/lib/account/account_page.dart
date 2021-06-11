import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/NewsFeed/create_blog.dart';
import 'package:first_app/NewsFeed/my_blog.dart';
import 'package:first_app/Sell/MyProduct.dart';
import 'package:first_app/account/edit_info.dart';
import 'package:first_app/buy_products/show_cart_0.dart';
import 'package:first_app/login_reg_pages/loading.dart';
import 'package:first_app/login_reg_pages/login_page.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/Sell/addProduct.dart';
import 'package:first_app/my_orders/my_orders_screen.dart';
import 'package:first_app/services/handbookService.dart';
import 'package:first_app/services/productService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:first_app/page_bottomNavBar/liked_page.dart';
class AccountPage extends StatefulWidget {
  User user;
  @override
  _AccountPageState createState() => _AccountPageState();
  AccountPage({this.user});
}
class _AccountPageState extends State<AccountPage> {
  var posted=0;
  var  article =0;
  bool viewResult = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProductService().getAllProductByPersonal(widget.user.uid).then((QuerySnapshot docs){
      setState(() {
        this.posted = docs.documents.length;
      });
    });
    handbookService().getHandBook(widget.user.uid).then((QuerySnapshot docs){
      setState(() {
        this.article = docs.documents.length;
        this.viewResult = true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return this.viewResult ? Scaffold(
        body: Column(
            children: [
              SizedBox(height: 40),
              Container(
                height: 180,
                child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Row(
                          children: [
                            SizedBox(width: 20,),
                          Column(
                            children:  [
                              //SizedBox(width: 100,),
                              Container(
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                                    child: Image.network(
                                      widget.user.getUrlImage(),
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ],
                          ),
                            SizedBox(width: 20,),
                            Column(
                              children: [
                                SizedBox(height: 50,),
                                Text(
                                  widget.user.getUserName(),
                                  style: TextStyle(
                                      color: Color.fromRGBO(254, 142, 142,1),
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text("Bài đăng", style: TextStyle(fontSize: 18, color: Color.fromRGBO(254, 142, 142, 1)),),
                                        Text(
                                          this.posted.toString(),
                                          style: TextStyle(fontSize: 18, color: Color.fromRGBO(254, 142, 142, 1)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 30,),
                                    Column(
                                      children: [
                                        Text("Bài viết",  style: TextStyle(fontSize: 18, color: Color.fromRGBO(254, 142, 142, 1))),
                                        Text(
                                          this.article.toString(),
                                          style: TextStyle(fontSize: 18, color: Color.fromRGBO(254, 142, 142, 1)),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )

                          ]
                        ),
                      ),
                    ]),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(4294896101)
                    ),
                    child: Column(
                        children: [
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              SizedBox(width: 12,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  height: 120,
                                  child:  ElevatedButton(
                                    onPressed: () async {
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) =>
                                              EditInfo(user: widget.user))).then((value) {
                                        if(value!=null){
                                          setState(() {
                                            widget.user = value;
                                          });
                                        }
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Icon(Icons.account_circle_rounded, color: Color.fromRGBO(254, 142, 142,1),size: 60,),
                                        Text(" Thông tin cá", style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromRGBO(254, 142, 142,1)),),
                                        Text("nhân", style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromRGBO(254, 142, 142,1)),),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              //side: BorderSide(color: Colors.red)
                                          )
                                    ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.white24)),
                                    )),
                              SizedBox(width: 12,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  height: 120,
                                  child:  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (
                                          context) => showCart(widget.user)));
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5,),
                                        Icon(Icons.add_shopping_cart_outlined, color: Color.fromRGBO(254, 142, 142,1),size: 60,),
                                       // SizedBox(height: 12,),
                                        Text("Giỏ hàng ", style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromRGBO(254, 142, 142,1)),),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              //side: BorderSide(color: Colors.red)
                                            )
                                        ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.white24)),
                                  )),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Container(
                            height: 2,
                            decoration: BoxDecoration(color: Colors.white),
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              SizedBox(width: 12,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  height: 120,
                                  child:  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (
                                          context) => LikedPage(user: widget.user,),));
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5,),
                                        Icon(
                                          FontAwesomeIcons.solidHeart,
                                          color: Color(4294872718),
                                          size: 60.0,
                                        ),
                                        SizedBox(height: 12,),
                                        Text("Lượt thích", style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromRGBO(254, 142, 142,1)),),

                                      ],
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              //side: BorderSide(color: Colors.red)
                                            )
                                        ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.white24)),
                                  )),
                              SizedBox(width: 12,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  height: 120,
                                  child:  ElevatedButton(
                                     onPressed: () {
                                        Navigator.push(context,  MaterialPageRoute(builder: (context) => MyProduct(user: widget.user,)));
                                      },
                                    child: Column(
                                      children: [
                                        Icon(Icons.assignment, color: Color.fromRGBO(254, 142, 142,1),size: 60,),
                                        SizedBox(height: 10,),
                                        Text("Bài đã đăng ", style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromRGBO(254, 142, 142,1)),),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              //side: BorderSide(color: Colors.red)
                                            )
                                        ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.white24)),
                                  )),

                            ],
                          ),

                          SizedBox(height: 15,),

                          Container(
                            height: 2,
                            decoration: BoxDecoration(color: Colors.white),
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              SizedBox(width: 12,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  height: 120,
                                  child:  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (
                                          context) => CreateBlog(user: widget.user,)));
                                    },
                                    child: Column(
                                      children: [
                                        Icon(Icons.wb_incandescent_rounded, color: Color.fromRGBO(254, 142, 142,1),size: 60,),
                                        Text("Chia sẻ kỹ ", style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromRGBO(254, 142, 142,1)),),
                                        Text("năng", style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromRGBO(254, 142, 142,1)),),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              //side: BorderSide(color: Colors.red)
                                            )
                                        ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.white24)),
                                  )),
                              SizedBox(width: 12,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  height: 120,
                                  child:  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (
                                          context) =>
                                          MyBlog(user: widget.user,)));
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5,),
                                        Icon(Icons.web_outlined, color: Color.fromRGBO(254, 142, 142,1),size: 60,),
                                        //SizedBox(height: 8,),
                                        Text("Các bài viết", style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromRGBO(254, 142, 142,1)),),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              //side: BorderSide(color: Colors.red)
                                            )
                                        ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.white24)),
                                  )),
                            ],
                          ),
                          SizedBox(height: 15,),
                          Container(
                            height: 2,
                            decoration: BoxDecoration(color: Colors.white),
                          ),
                          SizedBox(height: 15,),
                          Row(
                            children: [
                              SizedBox(width: 12,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  height: 120,
                                  child:  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (
                                          context) =>
                                          MyOrdersScreen(user: widget.user,)));
                                    },
                                    child: Column(
                                      children: [
                                        Icon(Icons.history, color: Color.fromRGBO(254, 142, 142,1),size: 60,),
                                        Text(" Lịch sử mua ", style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromRGBO(254, 142, 142,1)),),
                                        Text("hàng", style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromRGBO(254, 142, 142,1)),),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              //side: BorderSide(color: Colors.red)
                                            )
                                        ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.white24)),
                                  )),
                              SizedBox(width: 12,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  height: 120,
                                  child:  ElevatedButton(
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                      Navigator.push(context, MaterialPageRoute(builder: (
                                          context) => loginPage()));
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(height: 5,),
                                        Icon(Icons.west_rounded, color: Color.fromRGBO(
                                            254, 142, 142, 1.0),size: 60,),
                                        //SizedBox(height: 12,),
                                        Text("Đăng xuất", style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromRGBO(254, 142, 142,1)),),
                                      ],
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              //side: BorderSide(color: Colors.red)
                                            )
                                        ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.white24)),
                                  )),
                            ],
                          ),
                          SizedBox(height: 15,),
                        ]),
                  ),
                ),
              ),
            ])
    ) : Loading();
  }

}