class specialDay{
  String specialDayName;
  String imageUrl;
  specialDay({ this.specialDayName, this.imageUrl});

  // load Json to Object
  String getSpecialDay(){
    return this.specialDayName;
  }
  String getImageUrl(){
    return this.imageUrl;
  }

  factory specialDay.fromJson(Map<String, dynamic> json) => specialDay(
      specialDayName : json['specialDay'],
      imageUrl : json['imageUrl']
  );
}