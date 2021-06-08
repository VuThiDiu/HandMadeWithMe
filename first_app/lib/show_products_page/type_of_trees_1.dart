import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/Sell/ProductITem.dart';
import 'package:first_app/login_reg_pages/loading.dart';
import 'package:first_app/models/feedBack.dart';
import 'package:first_app/models/plant.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/plant_service.dart';
import 'package:first_app/services/productService.dart';
import 'package:first_app/show_products_page/SuggestionItem.dart';
import 'package:first_app/show_products_page/group_of_trees_0.dart';
import 'package:first_app/show_products_page/search_box_012.dart';
import 'package:first_app/show_products_page/show_items_3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'TreeItem.dart';

class TypeOfTrees extends StatefulWidget {
  User user;
  String specialDay;
  @override
  _TypeOfTreesState createState() => _TypeOfTreesState();
  TypeOfTrees(this.specialDay, this.user);
}

class _TypeOfTreesState extends State<TypeOfTrees> {


  var  viewResult = 0;
  List<Plants> listPlantGroupByCategory = new List();
  List<Product> listProduct = new List();
  PageController controller =
      PageController(viewportFraction: 0.4, initialPage: 1);

  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return (this.viewResult == 1) ? Scaffold(
      appBar: AppBar(
          toolbarHeight: 75,
          title: Text(
            widget.specialDay,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w700
            ),
          ),
          //title: SearchBox(text: 'NameTypeOfTree'),
          leadingWidth: 20,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          centerTitle: true,
          backgroundColor: Color(4294945450),
          actions: [
            IconButton(
              icon: Icon(
                FontAwesomeIcons.bell,
                color: Colors.black,
                size: 27.0,
              ),
              onPressed: () {},
            )
          ]),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
          child: Column(
        children: <Widget>[
          Container(
              height: 600,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10,),
                  Expanded(
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7),

                        itemCount: this.listProduct.length,
                        itemBuilder: (context, index){

                          return TreeItem(
                            product: this.listProduct[index],
                            user: widget.user,
                          );

                        }
                    ),

                  ),

                ],
              )),
        ],
      )),
      //bottomNavigationBar: BottomNavBar(),
    ) : Loading();
  }

  @override
  void initState() {

    // PlantService().getPlantsGroupByCategory(widget.categoryId).then((QuerySnapshot docs){
    //   if(docs.documents.isNotEmpty){
    //       docs.documents.forEach((element) {
    //           listPlantGroupByCategory.add(Plants.fromJson(element.data));
    //       });
    //   }
    //   setState(() {
    //     this.viewResult += 1;
    //   });
    // });


    int count ;
    List<Product> newList = new List();
    ProductService().getAllProductInSpecialDay(widget.specialDay).then((QuerySnapshot docs){
      count = docs.documents.length;
      if(count == 0){
        setState(() {
          this.viewResult+=1;
        });
      }
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
              newList.sort((a,b){
                return b.sold.toString().compareTo(a.sold.toString());
              });
              this.setState(() {
                this.listProduct = newList;
                this.viewResult+=1;
              });
            }
          });
        });
      }
    });

  }
}
