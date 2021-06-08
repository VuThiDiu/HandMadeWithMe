import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/login_reg_pages/loading.dart';
import 'package:first_app/models/categories.dart';
import 'package:first_app/models/feedBack.dart';
import 'package:first_app/models/plant.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/services/productService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'TreeItem.dart';

class ShowItem extends StatefulWidget {
  User user;
  Categories plants ;
  @override
  _ShowItemState createState() => _ShowItemState();
  ShowItem({this.plants, this.user});
}
@override
class _ShowItemState extends State<ShowItem> {

  List<Product> listProduct = new List();
  int _selectedIndex = 0;
  Widget _buildMenu(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 50.0,
        width: 100,
        decoration: BoxDecoration(
          color: Color(4294565598),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: loadingData(),
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            height: 600,
                            child: Column(
                              children: <Widget>[
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
                    )
                );
              }else{
                return Loading();
              }
            })

    );
  }

  loadingData() async {
   //  print('this is  a category Name'+  widget.plants.categoryName);
    int count;
    List<Product> newList = new List();
      ProductService().getAllProductByCategory(widget.plants.categoryName).then((QuerySnapshot docs){
        if(docs.documents.isNotEmpty){
          count = docs.documents.length;
          docs.documents.forEach((element) {
            List<String> imageList = new List();
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
            ProductService().getImageProduct(product.productID).then((QuerySnapshot image){
              if(image.documents.isNotEmpty){
                image.documents.forEach((element) {
                  imageList.add(element.data['imageUrl']);
                });
                product.setlistImage(imageList);
              }
              else product.setlistImage(['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGPL6RMbqGSqWK6sRGp537hVDb2q2fklxFrQ&usqp=CAU']);
              newList.add(product);
              if(newList.length == count){
                setState(() {
                  this.listProduct = newList;
                });
              }
            });

          });
        }

      });
      return this.listProduct;
  }}

    

