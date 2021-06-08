import 'package:flutter/material.dart';

class EditEmail extends StatefulWidget {
  @override
  _EditEmailState createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  String newEmail = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(4294945450) ,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Sửa Email", style: TextStyle(color: Colors.black, fontSize: 22, ),),
        centerTitle: true,
        actions: [
          FlatButton(
              onPressed: (){
                Navigator.pop(context, this.newEmail);
              },
              child: Text("Lưu", style: TextStyle( fontSize: 20, color: Colors.black),)),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black12.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Theme(
              data: new ThemeData(
                primaryColor: Colors.grey,
                primaryColorDark: Colors.grey,
              ),
              child: TextField(
                style: TextStyle(fontSize: 20.0),
                decoration: InputDecoration(contentPadding: EdgeInsets.all(8),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Email",
                  hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
                onChanged: (value){
                  this.newEmail = value;
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text("Dưới 100 kí tự", style: TextStyle(color: Colors.black54, fontSize: 18),),
            // )
          ],
        ),
      ),
    );
  }
}
