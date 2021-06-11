import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/Sell/MyProduct.dart';
import 'package:first_app/account/account_page.dart';
import 'package:first_app/login_reg_pages/loading.dart';
import 'package:first_app/models/SpecialDay.dart';
import 'package:first_app/models/categories.dart';
import 'package:first_app/models/product.dart';
import 'package:first_app/models/transport.dart';
import 'package:first_app/models/user.dart';
import 'package:first_app/sell/transport.dart';
import 'package:first_app/services/category_service.dart';
import 'package:first_app/services/productService.dart';
import 'package:first_app/services/specialDayService.dart';
import 'package:first_app/services/uploadFile.dart';
import 'package:first_app/show_products_page/body_home_0.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  User user;
  @override
  _AddProductState createState() => _AddProductState();
  AddProduct({this.user});

}

class _AddProductState extends State<AddProduct>{
  //SpecificationProduct specificationProduct;
  TransportProduct transportProduct;
  String title='';
  String description='' ;
  String category;
  String height='';
  String amount='';
  String address;
  String event;
  String material = '';
  DateTime date=DateTime.now();
  bool enableFeature = false;
  final picker = ImagePicker();
  List<File> _image =[];
  CollectionReference imgRef;
  File imageFile;
  String quantityInStock='';
  List<Categories> listPlants = new List();
  List<specialDay> lisSpecialDay = new List();
  var  viewResult = 0;
  List<String> listCities = ['An Giang', 'Bà Rịa – Vũng Tàu', 'Bắc Giang', 'Bắc Kạn','Bạc Liêu', 'Bắc Ninh',
  'Bến Tre', 'Bình Định','Bình Dương','Bình Phước','Bình Thuận','Cà Mau','Cần Thơ','Cao Bằng','Đà Nẵng','Đắk Lắk','Đắk Nông','Điện Biên','Đồng Nai','Đồng Tháp','Gia Lai','Hà Giang','Hà Nam','Hà Nội','Hà Tĩnh','Hải Dương','Hải Phòng','Hậu Giang','Hòa Bình','Hưng Yên','Khánh Hòa','Kiên Giang',
  'Kon Tum','Lai Châu','Lâm Đồng','Lạng Sơn','Lào Cai','Long An','Nam Định','Nghệ An','Ninh Bình','Ninh Thuận','Phú Thọ','Phú Yên','Quảng Bình','Quảng Nam','Quảng Ngãi','Quảng Ninh','Quảng Trị','Sóc Trăng','Sơn La','Tây Ninh','Thái Bình','Thái Nguyên','Thanh Hóa','Thừa Thiên Huế','Tiền Giang','TP Hồ Chí Minh','Trà Vinh','Tuyên Quang','Vĩnh Long','Vĩnh Phúc','Yên Bái',
  ];
  whenCompleted(){

    if(this.title!='' && this.description!=''&&this.material !='' &&this.amount!='' && this.category!=null && this.transportProduct!=null && this.quantityInStock != '' && this.address!=null){
      return true;
    }
    return false;
  }

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (picture != null) {
        _image.insert(0, File(picture.path));
      }
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      _image.insert(0, File(picture.path));
    });
    Navigator.of(context).pop();
  }


  @override
  void initState() {
    super.initState();
    CategoryService().getCategories().then((QuerySnapshot docs){
      if(docs.documents.isNotEmpty){
        setState(() {
          this.viewResult +=1;
        });
        docs.documents.forEach((element) {
          this.listPlants.add(Categories.fromJson(element.data));
        });
      }else{
        setState(() {
          this.viewResult +=1;
        });
      }
    });
    specilaDayService().getSpecialDay().then((QuerySnapshot docs){
      if(docs.documents.isNotEmpty){
        setState(() {
          this.viewResult +=1;
        });
        docs.documents.forEach((element) {
          this.lisSpecialDay.add(specialDay.fromJson(element.data));
        });
      }else{
        setState(() {
          this.viewResult +=1;
        });
      }
    });

  }

  Future<void> _showChoiceDialog(BuildContext context) {

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Thêm hình",
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("Chọn sẵn có"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      })
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build (BuildContext context) {
    return (this.viewResult==2) ? Scaffold(
      appBar: AppBar(
        backgroundColor: Color(4294945450),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Thêm sản phẩm',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Container(
                  padding: EdgeInsets.all(4),
                  child: Expanded(child: SizedBox(
                    height: 150,
                    width: 300,
                    child: new GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4),
                      itemCount: _image.length + 1,
                      itemBuilder: ((context, index){
                        return (index == 0) ? Center(
                          child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () =>
                                  _showChoiceDialog(context)),
                        ) : Container(
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(_image[index - 1]),
                                fit: BoxFit.cover),
                          ),
                        );
                      }),
                    ),
                  ))
              )
            ]),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: TextFormField(
                decoration: InputDecoration(
                    filled: true,
                    hintText: 'Nhập tên sản phẩm',
                    labelText: 'Tên sản phẩm',
                    labelStyle: TextStyle(fontSize: 26, color: Colors.black, fontWeight: FontWeight.w500, fontFamily: 'Merriweather'),
                    hintStyle: TextStyle(fontSize: 18, color: Colors.black45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.black, width: 5),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                maxLines: 2,
                maxLength: 100,
                onChanged: (value) {
                  setState(() {
                    this.title = value;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Mô tả hoặc ý nghĩa của sản phẩm',
                  labelText: 'Mô tả sản phẩm',
                  labelStyle: TextStyle(fontSize: 26, color: Colors.black, fontWeight: FontWeight.w500, fontFamily: 'Merriweather'),
                  hintStyle: TextStyle(fontSize: 18, color: Colors.black45),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Colors.black, width: 10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                maxLines: 6,
                maxLength: 1000,
                onChanged: (value) {
                  setState(() {
                    this.description = value;
                  });
                },
              ),
            ),
            SizedBox(height: 10,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.class__outlined),
                    Text(
                      '  Sự kiện ',
                      style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600,fontFamily: 'Merriweather'),
                    ),
                    SizedBox(width: 45,),
                    Expanded(child: new InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.black87, width: 20)
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child:  DropdownButton(
                          hint: Text('Select'),
                          value: event,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          elevation: 16,
                          isExpanded: true,
                          isDense: true,
                          //underline: ,
                          style: const TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w500),
                          onChanged: (newValue){
                            setState(() {
                              this.event = newValue;
                            });
                          },

                          items: lisSpecialDay
                              .map((specialDay value) {
                            return DropdownMenuItem<String>(
                              value: value.getSpecialDay().toString(),
                              child: Text(value.getSpecialDay().toString()),
                            );
                          }).toList(),
                        ),
                      ),
                    ),)
                  ],
                )
            ),
            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.monetization_on_sharp),
                  Text(
                    '  Giá sản phẩm (đồng) ',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600,fontFamily: 'Merriweather'),
                  ),
                  //
                  Expanded(
                    child: new TextField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.green,
                          hintText: 'Nhập ',
                          hintStyle: TextStyle(color: Colors.black45, decoration: TextDecoration.underline, fontSize: 18) ),
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20),
                      onChanged: (value){
                        setState(() {
                          this.amount = value;
                        });

                      },
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.multitrack_audio_outlined),
                  Text(
                    '  Chất liệu ',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600,fontFamily: 'Merriweather'),
                  ),
                  //
                  Expanded(
                    child: new TextField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.green,
                          hintText: 'Nhập ',
                          hintStyle: TextStyle(color: Colors.black45, decoration: TextDecoration.underline, fontSize: 18) ),
                      style: TextStyle(fontSize: 20),
                      onChanged: (value){
                        setState(() {
                          this.material = value;
                        });

                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.account_balance_rounded),
                  Text(
                    '  Số lượng trong kho ',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600,fontFamily: 'Merriweather'),
                  ),
                  //
                  Expanded(
                    child: new TextField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: Colors.green,
                          hintText: 'Nhập ',
                          hintStyle: TextStyle(color: Colors.black45, decoration: TextDecoration.underline, fontSize: 18) ),
                      textDirection: TextDirection.rtl,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 20),
                      onChanged: (value){
                        setState(() {
                          this.quantityInStock = value;
                        });

                      },
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: <Widget>[
                    Row(
                      children:<Widget>[
                        Icon(Icons.category_rounded),
                        Text(
                          '  Phân loại sản phẩm ',
                          style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600,fontFamily: 'Merriweather'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.black87, )
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      child: DropdownButtonHideUnderline(

                        child:  DropdownButton(
                          hint: Text('Select'),
                          value: category,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          elevation: 16,
                          isExpanded: true,
                          isDense: true,
                          //underline: ,
                          style: const TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w500),
                          onChanged: (newValue){
                            setState(() {
                              category=newValue;
                            });
                          },

                          items: listPlants
                              .map((Categories value) {
                            return DropdownMenuItem<String>(
                              value: value.categoryName.toString(),
                              child: Text(value.categoryName.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                )
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(),
              child: FlatButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Transport()),
                  ).then((value){
                    if(value!=null)
                    setState(() {
                      this.transportProduct = value;
                    });
                  });
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.train_outlined),
                    Expanded(
                      child:
                      Text(
                        '  Phí vận chuyển',
                        style: TextStyle(fontSize: 19,fontFamily: 'Merriweather'),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),

              ),
            ),

            SizedBox(height: 10,),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: <Widget>[
                        Icon(Icons.add_location),
                        Text(
                          ' Địa chỉ shop ',
                          style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600,fontFamily: 'Merriweather'),
                        ),
                    SizedBox(width: 20),
                    Expanded(child: new InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.black87, )
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child:  DropdownButton(
                          hint: Text('Select'),
                          value: address,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          elevation: 16,
                          isExpanded: true,
                          isDense: true,
                          //underline: ,
                          style: const TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.w500),
                          onChanged: (newValue){
                            setState(() {
                              address=newValue;
                            });
                          },

                          items: listCities
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value.toString(),
                              child: Text(value.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                    ),)
                  ],
                )
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children:<Widget> [
                  Icon(Icons.addchart),
                  Text(
                    '  Hàng đặt trước',
                    style: TextStyle(fontSize: 19,fontWeight: FontWeight.w600,fontFamily: 'Merriweather'),
                  ),
                  new Spacer(),
                  Switch(
                      activeColor: Color(4294945450),
                      value: enableFeature,
                      onChanged: (enabled){
                        setState(() {
                          enableFeature = enabled;
                        });
                      }
                  )
                ],
              ),
            ),
            SizedBox(height: 15,),
            RaisedButton(
              color: Color(4294344335),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onPressed: () async {
                if(whenCompleted()==true){
                  if(this.event == null) this.event = "";
                    Product product = new Product(productName: this.title,price: this.amount,  weight: this.transportProduct.weight, fastDelivery: this.transportProduct.fastDelivery, quantityInStock: this.quantityInStock,preOrder: this.enableFeature, address: this.address, accountID:  widget.user.uid, category: this.category, description: this.description, event: this.event, material: this.material);
                    String image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGPL6RMbqGSqWK6sRGp537hVDb2q2fklxFrQ&usqp=CAU";
                    ProductService().createProduction(product).then((value){
                      if(_image.length>0){
                        var  index = 0;
                        _image.forEach((element) {
                          uploadFile().uploadImageProduct(value, element, index);
                          index ++;
                        });
                      }
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AccountPage(user: widget.user,)));
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MyProduct(user: widget.user,)));

                    });

                }else {
                  Fluttertoast.showToast(msg: "Vui lòng điền đầy đủ thông tin");
                }
              },
              child: Text(
                'Lưu'.toUpperCase(),
                style: TextStyle(fontSize: 20,color: Colors.black,),
              ),
            )
          ],
        ),
      ),
    ) : Loading();
  }

}
