class Categories{
  String categoryName;
  String imageUrl;
  Categories({ this.categoryName, this.imageUrl});

  // load Json to Object
  String getCategoryName(){
    return this.categoryName;
  }
  String getImageUrl(){
    return this.imageUrl;
  }

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
    categoryName : json['categoryName'],
    imageUrl : json['imageUrl']
  );
}