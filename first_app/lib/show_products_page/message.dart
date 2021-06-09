import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/login_reg_pages/loading.dart';
import 'package:first_app/models/ChatMessage.dart';
import 'package:first_app/services/ChatService.dart';
import 'package:first_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class message extends StatefulWidget{
  String shopID;
  String accountId;
  @override
  _messState createState()  => _messState();

  message(this.shopID, this.accountId);
}


class _messState extends State<message>{
  String urlImageShop='';
  String nameShop = '';
  String content = '';
  bool viewResult = false;
  bool isClear =  false;
  List <chatMessage> listChat = new List();
  var _controler = TextEditingController();
  @override
  void initState() {
    Database().getUser(widget.shopID).then((value){
      setState(() {
        this.urlImageShop = value['urlImage'];
        this.nameShop = value['userName'];
        this.viewResult =  true;
      });
    });
  }
  loadingData() async {
    int count;
    List<chatMessage> rawData = new List();
    ChatService().getAllMess(widget.accountId, widget.shopID).then((QuerySnapshot value){
      count = value.documents.length;
      if(value.documents.isNotEmpty) {
        value.documents.forEach((element){
          rawData.add(chatMessage.fromJson(element.data));
            if(rawData.length == count)
            {
              setState(() {
                this.listChat = rawData;
              });
            }
        });
      }
    });
    return this.listChat;
  }
  @override
  Widget build(BuildContext context) {
    return this.viewResult ? Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back,color: Colors.black,),
                  ),
                  SizedBox(width: 2,),
                  CircleAvatar(
                    backgroundImage: NetworkImage(this.urlImageShop.toString()),
                    maxRadius: 20,
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(this.nameShop,style: TextStyle( fontSize: 16 ,fontWeight: FontWeight.w600),),
                        SizedBox(height: 6,),
                        Text("Online",style: TextStyle(color: Colors.grey.shade600, fontSize: 13),),
                      ],
                    ),
                  ),
                 // Icon(Icons.settings,color: Colors.black54,),
                ],
              ),
            ),
          ),
        ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: FutureBuilder(
              future: loadingData(),
              builder: (content, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return Padding(
                    padding: EdgeInsets.only(bottom : 40.0),
                    child: ListView.builder(
                      itemCount: listChat.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index){
                        return Container(
                          padding: EdgeInsets.only(left: 14,right: 14,top: 0,bottom: 20),
                          child: Align(
                            alignment: (listChat[index].isSend == false?Alignment.topLeft:Alignment.topRight),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (listChat[index].isSend == true?Color(4294565598):Colors.grey.shade200),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text(listChat[index].content, style: TextStyle(fontSize: 15),),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }else{
                  return Loading();
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Color(4294945450),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20, ),
                    ),
                  ),
                  SizedBox(width: 15,),
                  Expanded(
                    child: TextField(
                      controller: _controler,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                      ),
                      onChanged: (value){
                        setState(() {
                          this.content=value;
                        });
                        if(isClear == true){
                          _controler.clear();
                          setState(() {
                            this.isClear = false;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){
                      if(this.content!='')
                        {
                          ChatService().createMessage(widget.accountId, widget.shopID, this.content);
                          setState(() {
                            this.isClear = true;
                          });
                        }

                    },
                    child: Icon(Icons.send,color: Colors.white,size: 18,),
                    backgroundColor: Color(4294945450),
                    elevation: 0,
                  ),
                ],

              ),
            ),
          ),
        ],
      ),

    ) : Loading();
  }
}