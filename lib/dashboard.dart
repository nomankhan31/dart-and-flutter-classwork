import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final CollectionReference cust =
      FirebaseFirestore.instance.collection('customer');

  final CollectionReference prod =
      FirebaseFirestore.instance.collection('product');

  int selectIndex = 0;

  void logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  // ================= Add Product Dialog =================

  void showProductDialog() {
    final TextEditingController pName = TextEditingController();
    final TextEditingController pPrice = TextEditingController();
    final TextEditingController pDes = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Add Product"),

          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: pName,
                  decoration: const InputDecoration(
                    labelText: "P_Name",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: pPrice,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "P_Price",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: pDes,
                  decoration: const InputDecoration(
                    labelText: "P_Description",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                String name = pName.text.trim();
                String price = pPrice.text.trim();
                String des = pDes.text.trim();

                double? pri = double.tryParse(price);

                if (name.isEmpty || price.isEmpty || pri == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please enter a valid product name and price",
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await prod.add({
                    'name': name,
                    'price': pri,
                    'description': des,
                  });

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Product added successfully",
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                      ),
                    );
                  }
                }
              },
              child: const Text("Add Product"),
            ),
          ],
        );
      },
    );
  }

  // ================= Edit Product Dialog =================

  void editProduct(
    String docID,
    Map<String, dynamic> data,
  ) {
    final TextEditingController name = TextEditingController(
      text: data['name']?.toString() ?? '',
    );

    final TextEditingController price = TextEditingController(
      text: data['price']?.toString() ?? '',
    );

    final TextEditingController des = TextEditingController(
      text: data['description']?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Edit Product"),

          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: des,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(dialogContext);
              }, 
            child: Text('cancel')),
            ElevatedButton(
              onPressed: ()async{
                String pName= name.text.trim();
                String pPrice = price.text.trim();
                String pDescription = des.text.trim();
              double? pri = double.tryParse(pPrice);
              if(pName.isEmpty || pri== null){
                ScaffoldMessenger.of(context).
                showSnackBar(SnackBar(
                  content: Text("please enter a valid name or price")));
                  return;
              }
              try{  
              prod.doc(docID).update;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("product add succssfulyy.....")));
              }
              catch(e){
                ScaffoldMessenger.of(context).
                showSnackBar(SnackBar
                (content: Text("$e")));
              }

              }, 
            child: Text("update"))
          ],
        );
      },
      
    );
  }
  // ================= Delete Product =================

  Future<void> deleteproduct(String docID)async{
bool? confirm=await showDialog(
  context: context,
 builder: (dialogContext)
 {
  return AlertDialog(
    title: Text("Delete Product"),
    content: Text('Are you sure for delete your product'),
    actions: [
      TextButton(onPressed: (){Navigator.pop(dialogContext,false);}, 
      child: Text("Cancel")),
      ElevatedButton(onPressed:
       (){Navigator.pop(dialogContext,true);},
       child: Text("Delete"),
       ),
    ],
  );
 }
 );
 if(confirm != true){
  return;
 }
 try{
  await prod.doc(docID).delete();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("Product is deleted")));
 }
 catch(e){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
 }
  }
// ================= Approved User =================
  Future<void> approveduser(String docID)async{
try{
  await cust.doc(docID).update({
    'status' : 'approved'
  });
  if(mounted){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("User Approved")));
  }
}
catch(e){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$e")));
}
  }
// ================= Reject User =================

  Future<void> rejectuser(String docID)async{
try{
  await cust.doc(docID).update({
    'status' : 'Rejected'
  });
  if(mounted){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("User Regected")));
  }
}
catch(e){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$e")));
}

  }
  // ================= Delete User =================

  Future<void>deleteuser(String docID)async{
bool? confirm = await showDialog(
  context: context,
 builder: (dialogContext){
return AlertDialog(
title: Text("delete user"),
content: const Text("are you sure?"),
actions: [
  TextButton(
    onPressed: (){Navigator.pop(context);},
   child: Text("Cancel")),
   ElevatedButton(
    onPressed: (){Navigator.pop(context);},
    child: Text("Delete")),
],
);
 }
 ); 
 if(confirm != true){
  return;
 }
 try
 {
  await cust.doc(docID).delete();
  if(mounted){
    ScaffoldMessenger.
    of(context).showSnackBar
    (SnackBar(content: Text("SuccssFully Deleted")));
  }
 }
 catch(e){
if(mounted){
  ScaffoldMessenger.of(context).
  showSnackBar(SnackBar(content: Text("Error in deleting User$e")));
}
 }
}
// ================= Edit User =================

void edituser(String docID, Map<String,dynamic>data){
  final TextEditingController nameedit =TextEditingController(
    text: data["name"] ?? '',
  );
  final TextEditingController ageedit =TextEditingController(
    text: data["name"] ?? '',
  );
  final TextEditingController emailedit =TextEditingController(
    text: data["name"] ?? '',
  );
  final TextEditingController passwordedit=TextEditingController(
    text: data["name"] ?? '',
  );
  showDialog(
    context: context,
   builder: (dialogContext){
    return AlertDialog(
  title: Text("Edit user"),
  content: SingleChildScrollView(
    child: Column(
      children: [
        TextField(
          controller: nameedit,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
          controller: ageedit,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
          controller: emailedit,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
          controller: passwordedit,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    ),
  ),
  actions: [
    TextButton(onPressed: (){Navigator.pop(dialogContext);},
     child: Text("cancel")),
     ElevatedButton(onPressed: ()async{
    String name = nameedit.text.trim();
    String age= ageedit.text.trim();
    String email= emailedit.text.trim();
    String password= passwordedit.text.trim();

    int? userage = int.tryParse('agetext');
    
    if(name.isEmpty || email.isEmpty || age == null || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please enter a valid value")));
      return;
    }
    try{
      await cust.doc(docID).update({
    'name' : name,
    'email' : email,
    'age' : age,
    'password' : password,
 });
 if(dialogContext.mounted){
  Navigator.pop(dialogContext);
 }
 if(mounted){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('user data updated')));
 }
    }
    catch(e){

    }
    }
    
     , child: Text("Update"))
  ],
    );
   });

}



  // ================= Build =================
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
