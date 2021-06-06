import 'dart:core';
import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_app/models/feedBack.dart';

class Product {
  String productID;
  String productName;
  String description;
  String price;
  String weight;
  String material;
  bool fastDelivery;
  String quantityInStock;
  bool preOrder;
  String address;
  String accountID;
  Timestamp created;
  String event;
  String category;
  List<String> listImage;
  int liked;
  int watched;
  int sold;
  double rating;
  List<feedBack> listFeedBack;

  setListFeedBack(List<feedBack> listFeedBack){
    this.listFeedBack = listFeedBack;
  }
  setlistImage(List<String> listImage){
    this.listImage = listImage;
  }
  setRating(double rating){
    this.rating = rating;
  }

  Product(
      {this.productID,
      this.productName,
      this.description,
      this.price,
      this.category,
      this.weight,
      this.fastDelivery,
      this.quantityInStock,
      this.preOrder,
      this.created,
      this.address,
      this.accountID,
      this.liked,
      this.sold,
      this.watched,
      this.event,
      this.material});
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productID: json['productID'],
    productName:  json['productName'],
    description: json['description'],
    price : json['price'],
    category : json['category'],
    event: json['event'],
    weight:  json['weight'],
    fastDelivery : json['fastDelivery'],
    quantityInStock :  json['quantityInStock'],
    preOrder : json['preOrder'],
    created: json['created'],
    address: json['address'],
    accountID: json['accountID'],
    sold: json['sold'],
    watched: json['watched'],
    liked: json['liked'],
    material: json['material']
  );

}