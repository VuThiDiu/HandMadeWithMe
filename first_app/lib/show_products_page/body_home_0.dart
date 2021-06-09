import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/login_reg_pages/loading.dart';
import 'package:first_app/models/SpecialDay.dart';
import 'package:first_app/models/categories.dart';
import 'package:first_app/models/feedBack.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/category_service.dart';
import 'package:first_app/services/productService.dart';
import 'package:first_app/services/specialDayService.dart';
import 'package:first_app/show_products_page/SuggestionItem.dart';
import 'package:first_app/show_products_page/group_of_trees_0.dart';
import 'package:first_app/show_products_page/search_box_012.dart';
import 'package:first_app/show_products_page/type_of_trees_1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bodyHome extends StatefulWidget {
  User user;
  @override
  _bodyHomeState createState() => _bodyHomeState();
  bodyHome({this.user});
}

class _bodyHomeState extends State<bodyHome> {
  List<specialDay> listSpecialDay = new List();
  List<Categories> listCategory = new List();
  List<Product> listProduct = new List();
  List<Product> listProductInterested = new List();
  var viewResult = 0;
  bool showResult = false;
  @override
  void initState() {
    super.initState();
    specilaDayService().getSpecialDay().then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        docs.documents.forEach((element) {
          listSpecialDay.add(specialDay.fromJson(element.data));
        });
        setState(() {
          this.viewResult += 1;
        });
      } else {
        setState(() {
          this.viewResult += 1;
        });
      }
    });
    CategoryService().getCategories().then((QuerySnapshot docs){
      if(docs.documents.isNotEmpty){
        docs.documents.forEach((element) {
          listCategory.add(Categories.fromJson(element.data));
        });
        setState(() {
          this.viewResult +=1;
        });
      }else{
        setState(() {
          this.viewResult += 1;
        });
      }
    });
  //   // top 10 những sản phẩm mới đăng
    int count ;
    List<Product> newList = new List();
    ProductService().top10NewProduct().then((QuerySnapshot docs){
      count = docs.documents.length;
      if(docs.documents.isNotEmpty){
        docs.documents.forEach((element) {
          Product product = Product.fromJson(element.data);
          double rating = 0;
          List<feedBack> listFeedBack = new List();
          ProductService().getALlRating(product.productID).then(( QuerySnapshot value){
            if(value.documents.isNotEmpty){
              value.documents.forEach((element) {
                rating +=element.data['rating'];
                listFeedBack.add(feedBack.fromJson(element.data));
              });
              rating = rating/(value.documents.length);
              product.setListFeedBack(listFeedBack);
              product.setRating(rating);
            }else {
              product.setRating(rating);
              product.setListFeedBack([]);
            }
          });
          ProductService().getImageProduct(element.data['productID']).then(( QuerySnapshot value){
            if(value.documents.isNotEmpty){
              List<String> listImage = new List();
              value.documents.forEach((element) {
                listImage.add(element.data['imageUrl']);
              });
              product.setlistImage(listImage);
            }
            else{
              product.setlistImage(['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGPL6RMbqGSqWK6sRGp537hVDb2q2fklxFrQ&usqp=CAU']);
            }
            newList.add(product);
            if(newList.length == count){
              this.setState(() {
                this.listProduct = newList;
                this.viewResult +=1;
              });
            }
          });

        });
      }else{
        setState(() {
          this.viewResult+=1;
        });
      }
    });
  // // top nhung san pham duoc xem nhieu nhats
  //
  //
    int countProduct ;
    List<Product> newProduct = new List();
    ProductService().top10InterestedProducts().then((QuerySnapshot docs){
      countProduct = docs.documents.length;
      if(docs.documents.isNotEmpty){
        docs.documents.forEach((element) {
          Product product = Product.fromJson(element.data);
          double rating = 0;
          List<feedBack> listFeedBack = new List();
          ProductService().getALlRating(product.productID).then(( QuerySnapshot value){
            if(value.documents.isNotEmpty){
              value.documents.forEach((element) {
                rating +=element.data['rating'];
                listFeedBack.add(feedBack.fromJson(element.data));
              });
              rating = rating/(value.documents.length);
              product.setListFeedBack(listFeedBack);
              product.setRating(rating);
            }else {
              product.setRating(rating);
              product.setListFeedBack([]);
            }
          });
          ProductService().getImageProduct(element.data['productID']).then(( QuerySnapshot value){
            if(value.documents.isNotEmpty){
              List<String> listImage = new List();
              value.documents.forEach((element) {
                listImage.add(element.data['imageUrl']);
              });
              product.setlistImage(listImage);
            }
            else{
              product.setlistImage(['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGPL6RMbqGSqWK6sRGp537hVDb2q2fklxFrQ&usqp=CAU']);
            }
            newProduct.add(product);
            if(newProduct.length == countProduct){
              this.setState(() {
                this.listProductInterested = newProduct;
                this.viewResult +=1;
              });
            }
          });
        });
      }else{
        setState(() {
          this.viewResult+=1;
        });
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    PageController controller =
          PageController(viewportFraction: 0.4, initialPage: 1);
          return (this.viewResult == 4)
          ? Stack(children: [
          Positioned(
          top: 0,
          child: Container(
            width: screenWidth,
            height: screenHeight * 0.174,
            child: homeAppBar(user: widget.user),
          ),
        ),
        Positioned(
            top: 130,
            //child: Expanded(
            child: Container(
                width: screenWidth,
                height: 600,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin:
                          EdgeInsets.only(left: 10, top: 10, bottom: 10),
                          child: Text(
                            "Ngày đặc biệt",
                            style: TextStyle(
                                color: Color(4294344335),
                                fontWeight: FontWeight.w700,
                                fontSize: 25),
                          ),
                        ),
                        ListTypeOfTrees(this.listSpecialDay, widget.user),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "Thể loại",
                            style: TextStyle(
                                color: Color(4294344335),
                                fontWeight: FontWeight.w700,
                                fontSize: 25),
                          ),
                        ),
                        ListGroupOfTrees(this.listCategory, widget.user),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "Được quan tâm",
                            style: TextStyle(
                                color: Color(4294344335),
                                fontWeight: FontWeight.w700,
                                fontSize: 25),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SuggestionItem(this.listProductInterested, widget.user),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Text(
                            "Gợi ý cho bạn",
                            style: TextStyle(
                                color: Color(4294344335),
                                fontWeight: FontWeight.w700,
                                fontSize: 25),
                          ),
                        ),
                        SizedBox(height: 10,),
                        SuggestionItem(this.listProduct, widget.user),
                        SizedBox(height: 10,)
                      ]
                        ),
                )
            )),
        Positioned(
          top: 55,
          child: Container(
            height: 350,
            width: screenWidth * 0.9,
            margin: EdgeInsets.only(left: 22),
            child: SearchBox(widget.user,"Searh"),
          ),
        ),
    ])
    : Loading();


  }
}

class homeAppBar extends StatefulWidget {
  User user;
  @override
  _homeAppBarState createState() => _homeAppBarState();

  homeAppBar({this.user});
}

class _homeAppBarState extends State<homeAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.175,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(4294945450), Color(4294565598)],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(45),
            bottomRight: Radius.circular(45),
          ),
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 32,
                      top: 15,
                    ),
                    child: RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Hi ",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w700)),
                        TextSpan(
                            text: "" + widget.user.getUserName().toString(),
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w700)),
                        TextSpan(
                            text: " !",
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w700)),
                      ],
                    )),
                  )),
            ],
          ),

          //SearchBox(text: 'Litte Gardent',
          //  onChanged: (value) {},
        ));
  }
}



class ListTypeOfTrees extends StatelessWidget {
  List<specialDay> listCategories = new List();
  User user;
  ListTypeOfTrees(this.listCategories, this.user);
  @override
  Widget build(BuildContext context) {
    PageController controller =
        PageController(viewportFraction: 0.6, initialPage: 1);
    List<Widget> banners = new List<Widget>();
    for (int i = 0; i < listCategories.length; i++) {
      var bannerView = Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TypeOfTrees(
                          listCategories[i].getSpecialDay(), user,
                        )));
          },
          child: Container(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color(4294565598),
                          offset: Offset(0, 140),
                          spreadRadius: 0,
                          blurRadius: 100.0),
                      BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 2.0,
                          blurRadius: 2.0),
                    ],
                  ),
                ),
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: Image.asset(
                      listCategories[i].getImageUrl(),
                      fit: BoxFit.cover,
                    )),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black])),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        listCategories[i].getSpecialDay(),
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
      banners.add(bannerView);
    }
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.width * 8 / 16,
        child: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: banners,
        ));
  }
}
