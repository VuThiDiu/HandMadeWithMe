class feedBack{
  String comment;
  double rate;
  String userName;
  String imageUrl;

  feedBack({this.comment, this.rate, this.userName, this.imageUrl});
  factory feedBack.fromJson(Map<String, dynamic> json) =>  feedBack(
    comment: json['feedBack'],
    rate: json['rating'],
    userName: json['userName'],
    imageUrl: json['imageUrl']
  );
}