import 'package:first_app/models/SpecialDay.dart';
import 'package:first_app/models/categories.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/show_products_page/search_box_012.dart';
import 'package:first_app/show_products_page/show_items_3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowItemPage extends StatefulWidget {
  User user;
  Categories plant;
  ShowItemPage(this.plant, this.user);

  @override
  _ShowItemPageState createState() => _ShowItemPageState();
}

class _ShowItemPageState extends State<ShowItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
          toolbarHeight: 75,
          title: Text(widget.plant.categoryName,
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w700
          ),),
          leadingWidth: 20,
          centerTitle: true,
          backgroundColor: Color(4294945450),
          actions: [
            IconButton(
              icon: Image.asset(
                'assets/alert.png',
                width: 35,
                height: 35,
                color: Colors.black,
              ),
              onPressed: () {

              },
            )
          ]),
      body: ShowItem(plants: widget.plant, user: widget.user,),
     //bottomNavigationBar: BottomNavBar(),
    );
  }
}
