

import 'package:first_app/login_reg_pages/register_check_OTP.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:first_app/models/user.dart';
import 'package:flutter/services.dart';
class regNumberPhone extends StatefulWidget {
  User user;
  @override
  _regNumberPhoneState createState() => _regNumberPhoneState();
  regNumberPhone({this.user});
}

class _regNumberPhoneState extends State<regNumberPhone> {
  String phoneNumber;
  double _currentSliderValue = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text('Register',
          style: TextStyle(fontSize: 22, color: Colors.black),),
        backgroundColor:  Color(4294945450),
      ),
      body: Column(
        children: [
          Slider(
            value: _currentSliderValue,
            activeColor:  Color(4294344335),
            min: 0,
            max: 3,
            divisions: 3,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {

            },
          ),
          SizedBox(height: 70,),
          Text('Nhập số điện thoại của bạn',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color:  Color(4294344335)
            ),
          textAlign: TextAlign.center,),
          SizedBox(height: 40,),
          Container(
            margin: EdgeInsets.fromLTRB(40, 0, 40, 40),
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Color(4294565598)),
                )
            ),
            child: TextFormField(
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color:  Color(4294344335)),
              decoration: InputDecoration(
                  hintText: ('Số điện thoại'),
                  hintStyle: TextStyle(fontSize: 20, color:  Color(4294344335)),
              ),
              autofocus: true,
              onChanged: (value){
                if(value[0] == "0"){
                  this.phoneNumber = "+84" + value.substring(1, value.length);
                }else
                  this.phoneNumber = value;
              },
              keyboardType: TextInputType.number,
            ),
          ),
          Flexible(
              child: RaisedButton(
                color:  Color(4294344335),
                padding: EdgeInsets.fromLTRB(140, 12, 140, 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                onPressed: () {
                  widget.user.setPhoneNumber(this.phoneNumber);
                  print(this.phoneNumber);
                 // _verifyPhone();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>regOTP(user: widget.user)));
                },
                child: Text("NEXT",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  ),),
              )
          ),
        ]
    )
    );
  }

}
