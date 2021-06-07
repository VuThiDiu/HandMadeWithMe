import 'package:first_app/login_reg_pages/register_email.dart';
import 'package:first_app/login_reg_pages/register_numberPhone.dart';
import 'package:flutter/material.dart';
import 'package:first_app/models/user.dart';
class regName extends StatefulWidget {
  User user;
  @override
  _regNameState createState() => _regNameState();
  regName(this.user);
}

class _regNameState extends State<regName> {
  String userName;
  double _currentSliderValue = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: Text('Register',
            style: TextStyle(fontSize: 22),),
          backgroundColor: Color.fromRGBO(255, 144, 181, 1),
        ),
        body: Column(
            children: [
              Slider(
                  value: _currentSliderValue,
                  activeColor: Color.fromRGBO(255, 144, 181, 1),
                  min: 0,
                  max: 3,
                  divisions: 3,
                  label: _currentSliderValue.round().toString(),
                onChanged: (double value) {

                },
                ),
              SizedBox(height: 70,),
              Text('Nhập họ và tên của bạn',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(255, 144, 181, 1)
                ),
                textAlign: TextAlign.center,),
              SizedBox(height: 40,),
              Container(
                margin: EdgeInsets.fromLTRB(40, 0, 40, 40),
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Color.fromRGBO(255, 144, 181, 1)),
                    )
                ),
                child: TextFormField(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromRGBO(255, 144, 181, 1)),
                  decoration: InputDecoration(
                    hintText: ('Họ tên đầy đủ'),
                    hintStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(255, 144, 181, 1)),
                  ),
                  autofocus: true,
                  onChanged: (val){
                    this.userName = val;
                  },
                ),
              ),
              Flexible(
                  child: RaisedButton(
                    color: Color.fromRGBO(255, 144, 181, 1),
                    padding: EdgeInsets.fromLTRB(140, 12, 140, 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    onPressed: () {
                      widget.user.setUserName(this.userName);
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => regNumberPhone(user: widget.user)));
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
