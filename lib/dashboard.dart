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

  // ================= Add Product =================

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
                final String name = pName.text.trim();
                final String price = pPrice.text.trim();
                final String des = pDes.text.trim();

                final double? pri = double.tryParse(price);

                if (name.isEmpty || pri == null) {
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
                        content: Text("Product added successfully"),
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

  // ================= Edit Product =================

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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String pName = name.text.trim();
                final String pPrice = price.text.trim();
                final String pDescription = des.text.trim();

                final double? pri = double.tryParse(pPrice);

                if (pName.isEmpty || pri == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please enter a valid name and price",
                      ),
                    ),
                  );
                  return;
                }

                try {
                  // IMPORTANT:
                  // update() must actually be called with a Map.
                  await prod.doc(docID).update({
                    'name': pName,
                    'price': pri,
                    'description': pDescription,
                  });

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Product updated successfully"),
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
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // ================= Delete Product =================

  Future<void> deleteproduct(String docID) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete Product"),
          content: const Text(
            "Are you sure you want to delete this product?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    try {
      await prod.doc(docID).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Product deleted"),
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
  }

  // ================= Approve User =================

  Future<void> approveduser(String docID) async {
    try {
      await cust.doc(docID).update({
        'status': 'approved',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User approved"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$e"),
          ),
        );
      }
    }
  }

  // ================= Reject User =================

  Future<void> rejectuser(String docID) async {
    try {
      await cust.doc(docID).update({
        'status': 'rejected',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User rejected"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$e"),
          ),
        );
      }
    }
  }

  // ================= Delete User =================

  Future<void> deleteuser(String docID) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: const Text("Are you sure?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    try {
      await cust.doc(docID).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Successfully deleted"),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error in deleting user: $e"),
          ),
        );
      }
    }
  }

  // ================= Edit User =================

  void edituser(
    String docID,
    Map<String, dynamic> data,
  ) {
    final TextEditingController nameedit = TextEditingController(
      text: data["name"]?.toString() ?? '',
    );

    final TextEditingController ageedit = TextEditingController(
      text: data["age"]?.toString() ?? '',
    );

    final TextEditingController emailedit = TextEditingController(
      text: data["email"]?.toString() ?? '',
    );

    final TextEditingController passwordedit = TextEditingController(
      text: data["password"]?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Edit User"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameedit,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ageedit,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailedit,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordedit,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
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
                final String name = nameedit.text.trim();
                final String age = ageedit.text.trim();
                final String email = emailedit.text.trim();
                final String password = passwordedit.text.trim();

                final int? userAge = int.tryParse(age);

                if (name.isEmpty ||
                    email.isEmpty ||
                    userAge == null ||
                    password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter valid values"),
                    ),
                  );
                  return;
                }

                try {
                  await cust.doc(docID).update({
                    'name': name,
                    'email': email,
                    'age': userAge,
                    'password': password,
                  });

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User data updated"),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$e"),
                      ),
                    );
                  }
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // ================= Dashboard Home =================

  Widget dashboadhome() {
    return StreamBuilder<QuerySnapshot>(
      stream: cust.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Error ${snapshot.error}"),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text("No data found"),
          );
        }

        final int totaluser = snapshot.data!.docs.length;

        int approvedUser = 0;
        int pendingUser = 0;
        int rejectedUser = 0;

        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;

          // FIXED: status, not stutus
          final String status =
              data['status']?.toString().toLowerCase() ?? 'pending';

          if (status == 'approved') {
            approvedUser++;
          } else if (status == 'rejected') {
            rejectedUser++;
          } else {
            pendingUser++;
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Using Wrap prevents overflow on smaller screens.
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  dashboardcard(
                    "Total User",
                    totaluser.toString(),
                    Icons.people,
                  ),
                  dashboardcard(
                    "Approved",
                    approvedUser.toString(),
                    Icons.check_circle,
                  ),
                  dashboardcard(
                    "Pending",
                    pendingUser.toString(),
                    Icons.pending,
                  ),
                  dashboardcard(
                    "Rejected",
                    rejectedUser.toString(),
                    Icons.cancel,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= Dashboard Card =================

  Widget dashboardcard(
    String title,
    String value,
    IconData icon,
  ) {
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
              ),
              const SizedBox(height: 20),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  // ================= Product Page =================

  Widget productpage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Product Page",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: showProductDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add Product'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: prod.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error ${snapshot.error}"),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No data found"),
                  );
                }

                final products = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final doc = products[index];

                    final data =
                        doc.data() as Map<String, dynamic>;

                    final String name =
                        data['name']?.toString() ?? '';

                    final String price =
                        data['price']?.toString() ?? '0';

                    final String description =
                        data['description']?.toString() ?? '';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text(
                          "Price: $price\n$description",
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                editProduct(
                                  doc.id,
                                  data,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                deleteproduct(doc.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= User Page =================

  Widget userpage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "User Management",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: cust.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error ${snapshot.error}"),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No users found"),
                  );
                }

                final users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final doc = users[index];

                    final data =
                        doc.data() as Map<String, dynamic>;

                    final String name =
                        data['name']?.toString() ?? '';

                    final String email =
                        data['email']?.toString() ?? '';

                    final String age =
                        data['age']?.toString() ?? '';

                    final String status =
                        data['status']?.toString() ?? 'pending';

                    return Card(
                      child: ListTile(
                        title: Text(name),
                        subtitle: Text(
                          "$email\nAge: $age\nStatus: $status",
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'approve') {
                              approveduser(doc.id);
                            } else if (value == 'reject') {
                              rejectuser(doc.id);
                            } else if (value == 'edit') {
                              edituser(doc.id, data);
                            } else if (value == 'delete') {
                              deleteuser(doc.id);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'approve',
                              child: Text("Approve"),
                            ),
                            const PopupMenuItem(
                              value: 'reject',
                              child: Text("Reject"),
                            ),
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text("Edit"),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= Build =================

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      dashboadhome(),
      userpage(),
      productpage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: pages[selectIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectIndex,
        onTap: (index) {
          setState(() {
            selectIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Users",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Products",
          ),
        ],
      ),
    );
  }
}
