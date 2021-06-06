import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(1, 241, 181, 217),
      child: Center(
        child: SpinKitChasingDots(
          color: Color.fromRGBO(1, 255, 114, 199),
          size: 50.0,
        ),
      ),
    );
  }
}