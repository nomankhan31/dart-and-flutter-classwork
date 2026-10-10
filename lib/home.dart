import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override

  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

// Variable's........................

int selectedIndex = 0;

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
  
  List<String> title =['Home' , 'cart' , 'Favorite', 'profile'];

  List<Widget> pages=[
    homepage(),
    cartpage(),
    favoritepage(),
    profilepage(),
  ];


    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.white70,
         foregroundColor: Colors.white38,
         centerTitle: true,
         title: Text(title[selectedIndex]),
         actions: [
          IconButton(onPressed: (){
            setState(() {
              selectedIndex=1;
            });
          }
        
          , icon: Badge(
            isLabelVisible: cartitems.isNotEmpty,
            label: Text(totalitem().toString()),
            child:  Icon(Icons.shopping_bag_outlined),
          )),

          Drawer(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      Username[0].toUpperCase(),
                      style: TextStyle(color: Colors.indigo,fontSize: 24),
                    ),
                  ),
                  accountName: Text(Username),
                   accountEmail: Text(useremail)),
                   ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: (){Navigator.pop(context);
                    setState(() {
                   selectedIndex =0;
                    });},
                   ),
                   SizedBox(height: 10,),
                   ListTile(
                    leading: Icon(Icons.shopping_bag_outlined),
                    title: Text('Cart'),
                    onTap: (){Navigator.pop(context);
                    setState(() {
                   selectedIndex =1;
                    });},
                   ),
                   SizedBox(height: 10,),
                   ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('Favorite'),
                    onTap: (){Navigator.pop(context);
                    setState(() {
                   selectedIndex =2;
                    });},
                   ),
                   SizedBox(height: 10,),
                   ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: (){Navigator.pop(context);
                    setState(() {
                   selectedIndex =3;
                    });},
                   ),
                   SizedBox(height: 10,),

                   Divider(),
                   ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Signout',style: TextStyle(color: Colors.red),),
                    onTap: signout,
                   ),
                   SizedBox(height: 10,)
              ],
            ),
          )
         ],
      ),



      //       Navigator bar ===========

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
          onTap: (index){
            setState(() {
              selectedIndex = index;
            });
          },
          
        items:  [
           BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
           BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),label: 'Cart'),
           BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'favorite'),
           BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile'),
        ]
        ),

        
      
    );
  }


//===============Home Page==============

Widget homepage(){
  return ListView(
    padding: EdgeInsets.all(8),
    children: [
      Text("Wellcome,$Username",
      style: TextStyle(fontSize: 20,
      fontWeight: FontWeight.bold),),
      SizedBox(height: 15,),

      TextField(
        controller: searchcontroller,
        onChanged: (value){
          setState(() {
            var Searchtext =value.trim().toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: "Search products",
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius:BorderRadius.circular(12),
            borderSide: BorderSide.none,
          )

        ),
      ),

      SizedBox(height: 20,),

      Text("Available Products",
      style: TextStyle(fontSize: 10,
      fontWeight: FontWeight.bold),),
      SizedBox(height: 10,),
      productList(false),

    ],
  );
  
  
}
}
