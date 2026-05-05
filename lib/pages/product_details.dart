import 'package:ecommerce_personal_vendor/pages/edit_product.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatefulWidget {
  final String name;
  final String description;
  final double price;
  final bool isAvailable;
  final Map<String,dynamic>addOns;
  final int productId;
  const ProductDetails({super.key, required this.name,
    required this.description,
    required this.price,
    required this.isAvailable,
    required this.addOns, required this.productId
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {



  @override void initState() {
    print(widget.addOns);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        backgroundColor: Colors.black,
        title: Text("Product details", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text("Name",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text(widget.name,style: TextStyle(fontSize: 20))),
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text("Price",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text(widget.price.toString(),style: TextStyle(fontSize: 20))),
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text("Description",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text(widget.description,style: TextStyle(fontSize: 20))),
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text("Addons",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)),
                  ],
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.addOns.length,
                    itemBuilder: (context,index){
                      final key = widget.addOns.keys.elementAt(index);
                      final value = widget.addOns[key];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(widget.addOns.isEmpty?"No addons":"$key: $value",style: TextStyle(fontSize: 20)),
                        ],
                      );
                    })
              ],
            ),
            SizedBox(height: 20,),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text("Availability",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600),)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: Text(widget.isAvailable?"Yes":"No",style: TextStyle(fontSize: 20))),
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProduct(
                    name: widget.name,
                    price: widget.price,
                    isAvailable: widget.isAvailable,
                    productId: widget.productId,
                    addOns: widget.addOns,
                    description: widget.description,
                  )));
                }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 5,),
                    Text("Edit food item"),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
