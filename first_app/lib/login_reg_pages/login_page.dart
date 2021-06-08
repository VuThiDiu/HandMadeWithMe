
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/login_reg_pages/register_welcome.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/page_bottomNavBar/summary_page.dart';
import 'package:first_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  String phoneNumber;
  String userName;
  String email;
  String password;
  String confirmPass;
  String verificationCode;
  String smsCode;
  bool _visible = false;
  final txt = TextEditingController();

  clearTextInput() {
    txt.clear();
  }

  @override
  Widget build(BuildContext context) {
    PageController controller =
    PageController(viewportFraction: 0.4, initialPage: 1);

    return Scaffold(
      body: SingleChildScrollView(
       child: Container(
         height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color.fromRGBO(254, 233, 229, 1),
            ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //SizedBox(height: ),

                    // SizedBox(height: 200),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child:  Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                          borderRadius:  BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                            )

                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Image.asset('assets/logo.png', width: 100, height: 100,),
                            // Row(
                            //   children: [
                            //     Image.asset('assets/logo.png', width: 100, height: 100,),
                            //
                            //
                            //   ],
                            // ),
                             Text("Sign in", style: TextStyle(
                               fontFamily: 'AkayaTelivigala',
                               color: Color(4294344335),
                               fontSize: 35,
                             ), ),
                           SizedBox(height: 50,),
                            _textInput(hint: "Number Phone", icon: Icons.phone,),
                            Visibility(visible: !_visible, child: SizedBox(height: 10,)),
                            Visibility(
                                visible: _visible,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: 10, bottom: 10, right: 30),
                                    alignment: Alignment.centerRight,
                                    child: Text("Account is not registered",
                                      style: TextStyle(
                                          color: Color.fromRGBO(254, 185, 185, 1)
                                      ),)
                                )),
                          Flexible(
                                child: RaisedButton(
                                  //padding: EdgeInsets.fromLTRB(150, 12, 150, 12),
                                  color: Color(4294344335),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                  ),

                                  onPressed: () async {
                                    FirebaseAuth.instance.signOut();
                                    _verifyPhone();
                                  },
                                  child: Text("LOGIN",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white
                                    ),
                                  ),
                                ),


                          ),
                            SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Don't have an account?  ",
                                      style: TextStyle(color: Color(4294344335), fontSize: 18),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) => regWel()));
                                      },
                                      child: Text("Registor",
                                        style: TextStyle(color:Color.fromRGBO(234, 30, 99, 1), fontSize: 18),
                                      ),
                                    )
                                  ]
                              ),
                            )

                          ],
                        ),


                      ),
                    ),
                    SizedBox(height: 100,)

                  ]
              ),
            )
      )
      );
  }

  Widget _textInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.0, color: Colors.white),
            left: BorderSide(width: 1.0, color: Colors.white),
          )
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Color(4294344335)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 20, color: Color(4294344335)),
          prefixIcon: Icon(icon, color: Color(4294344335)),
        ),
        onChanged: (value) {
          if (value[0] == "0") {
            this.phoneNumber = "+84" + value.substring(1, value.length);
          } else
            this.phoneNumber = value;
        },

      ),
    );
  }

  Future <void> _verifyPhone() async {
    print("inside verifyPhone");
    // Automatic handling of the SMS code on Android devices
        final PhoneVerificationCompleted verificationCompleted = (
            AuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        };


        // Handle failure events : invalid phoneNumber, ...
        final PhoneVerificationFailed phoneVerificationFailed = (
            AuthException exception) {
          print("${exception.message}");
        };

        // Handle when a code has been sent to the sevice form Firebase
        final PhoneCodeSent phoneCodeSent = (String verId, [int forceCodeResend]) {
          this.verificationCode = verId;
          smsCodeDialog(context).then((value) =>
          {
            print("Signed In")
          }
          );
        };

        final PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String verId) {
          this.verificationCode = verId;
        };


        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: this.phoneNumber,
            timeout: const Duration(seconds: 5),
            verificationCompleted: verificationCompleted,
            verificationFailed: phoneVerificationFailed,
            codeSent: phoneCodeSent,
            codeAutoRetrievalTimeout: autoRetrievalTimeout);


  }

  Future<bool> smsCodeDialog(BuildContext context) async {
    return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Enter Code",
                  style: TextStyle(
                      color: Color(4294344335),
                      fontSize: 20
                  ),),
                content: TextField(
                  controller: txt,
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    smsCode = val;
                    if (val.length == 6) {
                      FirebaseAuth.instance.currentUser().then((user) {
                        if (user != null) {
                          clearTextInput();
                          FirebaseAuth.instance.signOut();
                        } else {
                          clearTextInput();
                          //print('ơ hay');
                          signIn();
                        }
                      });
                    }
                  },
                  autofocus: true,
                  maxLength: 6,
                  style: TextStyle(
                    color: Color(4294344335),
                    fontSize: 30,
                    letterSpacing: 23,

                  ),
                ),
              );
            }
        );

  }

  signIn() {
    AuthCredential phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationCode, smsCode: smsCode);
    FirebaseAuth.instance.signInWithCredential(phoneAuthCredential).then((
        user) {
      Database().getUserInfo(user.user.uid.toString()).then((value) {
        if (value == null) {
          Navigator.of(context).pop();
          setState(() {
            this._visible = true;
          });
        }
        else{
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SummaryPage(user: value)));
        }

      });
    });
  }
}
