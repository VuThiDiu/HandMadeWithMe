import 'package:first_app/buy_products/show_cart_0.dart';
import 'package:first_app/login_reg_pages/loading.dart';
import 'package:first_app/models/feedBack.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/likeProduct.dart';
import 'package:first_app/services/purchase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:first_app/show_products_page/message.dart';

class DetailItem extends StatefulWidget {
  Product product;
  User user;
  @override
  _DetailItemState createState() => _DetailItemState();

  DetailItem({this.product, this.user});
}
class _DetailItemState extends State<DetailItem> {
  bool isFavorited= false;
  bool viewResult = false;
  @override
  void initState() {
    likeProduct().isLiked(widget.user.uid, widget.product.productID).then((value){
      if(value!=null)
      setState(() {
        this.isFavorited = value;
        this.viewResult=true;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    var setImage = isFavorited
        ? Image.asset(
      'assets/heart_like.png',
      width: 25,
    )
        : Image.asset(
      'assets/heart.png',
      width: 25,
    );

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return (this.viewResult) ?  Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
          toolbarHeight: 50,
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            widget.product.productName.toString(),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
                fontFamily: "Merriweather",
                fontSize: 25,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
          bottomOpacity: 0.0,
          flexibleSpace: Container(
              decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(4294945450), Color(4294565598)],
            ),
          )),
          actions: [
          IconButton(
          icon: (setImage),
        onPressed: () {
          setState(() {
            this.isFavorited = !this.isFavorited;
          });

          if(this.isFavorited){
            likeProduct().addFavoriteProduct(widget.user.getUid(), widget.product.productID);
          }else{
            likeProduct().deleteFavoriteProduct(widget.user.getUid(), widget.product.productID);
          }
        }),
          ]),
      body: Container(
        //height: 10000,
          child: SingleChildScrollView(
              child: Stack(
                  children: <Widget>[
        Column(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight * 0.46,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(4294565598), Color(4294565598)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Color(4294702324),
                        offset: Offset(0, 20),
                        spreadRadius: 4,
                        blurRadius: 20.0),
                  ]),
              child: _appBarDetail(context),
            ),
            SizedBox(
              height: 15,
            ),
            Row(children: [
              Positioned(
                bottom: 0,
                left: 15,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: screenWidth * 0.5,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '   Giá: '+widget.product.price+'d',
                              style: TextStyle(
                                fontFamily: "Merriweather",
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(4294945450), Color(4294565598)],
                        ),
                        borderRadius: BorderRadius.all(
                         Radius.circular(16),

                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 0),
                                  child: RaisedButton(
                                    textColor: Colors.black,
                                    color: Colors.white,
                                    child: Text(
                                      'Mua ngay',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    onPressed: () {
                                      PurchaseService().addProductToTheCart(widget.product.productID, 1, widget.user.uid, widget.product.accountID, widget.product.listImage.last, widget.product.productName, widget.product.price);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => showCart(widget.user)));
                                    },
                                    splashColor: Colors.black,
                                    shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: Row(children: <Widget>[
                                FlatButton(
                                  minWidth: 70,
                                  padding: EdgeInsets.all(2.0),
                                  color: Colors.white,
                                  child: Image.asset(
                                    "assets/message.png",
                                    width: 40,
                                    fit: BoxFit.cover,
                                  ),
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>message(widget.product.accountID, widget.user.uid, )));
                                  },
                                ),
                                FlatButton(
                                  minWidth: 60,
                                  color: Colors.white,
                                  child: Image.asset(
                                    "assets/addToCart.png",
                                    width: 60,
                                    fit: BoxFit.cover,
                                  ),
                                  onPressed: () {
                                    // adding product to them cart
                                    PurchaseService().addProductToTheCart(widget.product.productID, 1, widget.user.uid, widget.product.accountID, widget.product.listImage.last, widget.product.productName, widget.product.price);
                                    // Announcement of adding products to the cart
                                    showAlert(context);
                                  },
                                ),

                              ]),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mô tả sản phẩm ",
                  style: TextStyle(
                    fontFamily: "Merriweather",
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.product.description.toString(),
            ),),
            SizedBox(height: 15,),
            Positioned(
              bottom: 0,
              left: 15,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 18,),
                  Container(
                    width: screenWidth * 0.5,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Chi tiết ",
                            style: TextStyle(
                              fontFamily: "Merriweather",
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Kho: " + widget.product.quantityInStock.toString(),
                              style: TextStyle(fontSize: 16, height: 1.5),
                            )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Chất liệu: " + widget.product.material.toString(),
                              style: TextStyle(fontSize: 16, height: 1.5),
                            )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Gửi từ : " + widget.product.address.toString(),
                              style: TextStyle(fontSize: 16, height: 1.5),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
                SizedBox(height: 15,),
                (widget.product.rating != 0) ?
                    Column(
                      children: [

                        Row(
                          children: [
                            SizedBox(width: 18,),
                            RatingBarIndicator(
                              rating: widget.product.rating ,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 25.0,
                              direction: Axis.horizontal,
                            ),
                            Text('  ' + widget.product.rating.toString() + '/5 (' +widget.product.listFeedBack.length.toString()+ ' đánh giá )' ),
                          ],
                        ),

                        SizedBox(height: 5,),
                        for(int i =0 ; i< widget.product.listFeedBack.length; i++) CommentItem(widget.product.listFeedBack[i])
          
                      ],
                    )
                    : Text("Chưa có đánh giá ", style:
                TextStyle(fontSize: 16)),

         ],
        ),

      ]))),
    ) : Loading();
  }

  Widget _appBarDetail(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
        child: Row(children: [
          Container(
                    padding: const EdgeInsets.only(top: 30),
                    width: screenWidth,
                    child: ListView(
                      children: <Widget>[
                        Container(
                          height: 280,
                          child: new Carousel(
                            boxFit: BoxFit.cover,
                            images: widget.product.listImage.map((item) =>
                            NetworkImage(item.toString())).toList(),
                            autoplay: false,
                            animationCurve: Curves.fastOutSlowIn,
                            animationDuration: Duration(milliseconds: 1000),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ));
  }
  showAlert(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Image.asset("assets/checkIcon.png", width: 50, height: 50,),
      content: Text("Sản phẩm đã được thêm vào giỏ hàng"),
    );
    showDialog(
      context: context,
      builder: (BuildContext) {
        return alert;
      }
    );
  }


}

class CommentItem extends  StatefulWidget{
  feedBack feedBackItem;

  CommentItem(this.feedBackItem);

  @override
  _CommentItemState createState() => _CommentItemState();


}
class _CommentItemState extends State<CommentItem>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Positioned(
            bottom: 10,
            left: 15,
            child: Row(
              children: <Widget>[
                Container(
                  width:  MediaQuery.of(context).size.width* 0.3,
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20.0)),
                          child: Image.network(
                            widget.feedBackItem.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          child: Row(children: <Widget>[
                            Text(widget.feedBackItem.userName, style: TextStyle(fontSize: 16),),
                          ]),
                        ),
                        Container(
                          child: Row(children: <Widget>[
                            Text("")
                          ]),
                        ),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: widget.feedBackItem.rate ,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 16.0,
                              direction: Axis.horizontal,
                            ),
                          ],
                        ),
                        Container(
                          child: Row(children: <Widget>[
                           Text(widget.feedBackItem.comment)
                          ]),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],),
      ],
    );
  }

}

