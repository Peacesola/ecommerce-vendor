class Restaurant {
  final int? restaurantId;
  final String? restaurantName;
  final String email;
  final String? password;
  final bool? isOpen;
   Restaurant({ this.restaurantName,this.restaurantId, required this.email, this.password, this.isOpen,});

  Map<String,dynamic>toJson(){
     return{
       "restaurantName":restaurantName,
       "email":email,
       "password":password,
       "isOpen":isOpen
     };
  }

  factory Restaurant.fromJson(Map<String,dynamic>map){
    final me= map["me"];
    return Restaurant(
      restaurantId: me["id"]?? " ",
        restaurantName: me["restaurantName"]?? " ",
        email: me["email"]?? " ",
      isOpen: me["isOpen"]?? " "
    );
  }

}