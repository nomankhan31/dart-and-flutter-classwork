import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override

  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

// Variable's........................

int selectIndex = 0;

String Username = 'user';

String useremail = '';

String searchbar = '';

TextEditingController searchcontroller = TextEditingController();

final CollectionReference products = FirebaseFirestore.instance.collection('product');

List <Map<String, dynamic>> cartitems = [];

List<String> favorite =[];

// Card Function ................

void addtocart(String id, String name, double price){

bool found = false;

for(var item in cartitems){

if(item ['id'] == id){

  item ['qty'] = item ['qty'] + 1;
  
  found = true;
}

}
if(found!){

  cartitems.add({'id' : id , 'name' : name , 'price' : price , 'qty' : 1});
}
setState(() {});

ScaffoldMessenger.of(context).

showSnackBar(SnackBar(content: Text("Added to Cart"),

duration: Duration(seconds: 1),

));

}


void increseqty(Map< String , dynamic> item){

setState(() {

  if(item ['qty'] > 1){

item ['qty'] = item ['qty'] + 1;

  }

});

}


void decreseqty(Map< String , dynamic> item){

setState(() {

  if(item ['qty'] > 1){

item ['qty'] = item ['qty'] - 1;

  }

  else{cartitems.remove(item);}

});

}
int totalitem() {
  int total = 0;

  for (var item in cartitems) {
    total = total + (item['qty'] as int);
  }

  return total;
}

int pricetotal() {
  int total = 0;

  for (var item in cartitems) {
    total = total + ((item['price'] as int) * (item['qty'] as int));
  }

  return total;
}

// favorite ................

void togglefavorite( String id){

setState(() {
  
  if(favorite.contains(id)){

    favorite.remove(id);

  }
  else{
    favorite.add(id);
  }
});
}

// signout .......................

void signout(){

  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}











  @override

  Widget build(BuildContext context) {

    return const Placeholder();
  }
}
