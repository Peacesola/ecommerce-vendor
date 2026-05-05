class Food {
  final int? productId;
  final double price;
  final String? name;
  final Map<dynamic,dynamic>?addOns;
  final bool isAvailable;
  final String description;
  Food({this.productId, required this.price, this.name, this.addOns, required this.isAvailable, required this.description});

  Map<String,dynamic>toJson(){
    return{
      "name":name,
      "price":price,
      "description":description,
      "addOns":addOns,
      "isAvailable":isAvailable
    };
  }

  factory Food.fromJson(Map<String,dynamic>map){
    return Food(
      productId: map["productId"]?? " ",
      price: map["price"]?? " ",
        name: map["name"]?? " ",
      isAvailable: map["isAvailable"],
      addOns: map["addOns"]?? " ",
      description: map["description"]?? " ",

    );
  }

}