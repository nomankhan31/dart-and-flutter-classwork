import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // ================= FIRESTORE =================

  final CollectionReference cust =
      FirebaseFirestore.instance.collection('customer');

  final CollectionReference prod =
      FirebaseFirestore.instance.collection('product');

  int selectIndex = 0;

  // ================= LOGOUT =================

  void logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  // =========================================================
  // ADD PRODUCT
  // =========================================================

  void showProductDialog() {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Add Product"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
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
                final name = nameController.text.trim();
                final priceText = priceController.text.trim();
                final description =
                    descriptionController.text.trim();

                final price = double.tryParse(priceText);

                if (name.isEmpty || price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please enter valid product name and price",
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await prod.add({
                    "name": name,
                    "price": price,
                    "description": description,
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
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // EDIT PRODUCT
  // =========================================================

  void editProduct(
    String docID,
    Map<String, dynamic> data,
  ) {
    final nameController = TextEditingController(
      text: data["name"]?.toString() ?? "",
    );

    final priceController = TextEditingController(
      text: data["price"]?.toString() ?? "",
    );

    final descriptionController = TextEditingController(
      text: data["description"]?.toString() ?? "",
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Edit Product"),

          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Description",
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
                final name = nameController.text.trim();
                final priceText = priceController.text.trim();
                final description =
                    descriptionController.text.trim();

                final price = double.tryParse(priceText);

                if (name.isEmpty || price == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please enter valid information",
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await prod.doc(docID).update({
                    "name": name,
                    "price": price,
                    "description": description,
                  });

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Product updated successfully",
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
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // DELETE PRODUCT
  // =========================================================

  Future<void> deleteProduct(String docID) async {
    final confirm = await showDialog<bool>(
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

    if (confirm != true) return;

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

  // =========================================================
  // APPROVE USER
  // =========================================================

  Future<void> approveUser(String docID) async {
    try {
      await cust.doc(docID).update({
        "status": "approved",
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
            content: Text("Error: $e"),
          ),
        );
      }
    }
  }

  // =========================================================
  // REJECT USER
  // =========================================================

  Future<void> rejectUser(String docID) async {
    try {
      await cust.doc(docID).update({
        "status": "rejected",
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
            content: Text("Error: $e"),
          ),
        );
      }
    }
  }

  // =========================================================
  // DELETE USER
  // =========================================================

  Future<void> deleteUser(String docID) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete User"),

          content: const Text(
            "Are you sure you want to delete this user?",
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

    if (confirm != true) return;

    try {
      await cust.doc(docID).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User deleted successfully"),
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

  // =========================================================
  // EDIT USER
  // =========================================================

  void editUser(
    String docID,
    Map<String, dynamic> data,
  ) {
    final nameController = TextEditingController(
      text: data["name"]?.toString() ?? "",
    );

    final ageController = TextEditingController(
      text: data["age"]?.toString() ?? "",
    );

    final emailController = TextEditingController(
      text: data["email"]?.toString() ?? "",
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
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
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
                final name = nameController.text.trim();
                final ageText = ageController.text.trim();
                final email = emailController.text.trim();

                final age = int.tryParse(ageText);

                if (name.isEmpty ||
                    email.isEmpty ||
                    age == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please enter valid information",
                      ),
                    ),
                  );
                  return;
                }

                try {
                  await cust.doc(docID).update({
                    "name": name,
                    "age": age,
                    "email": email,
                  });

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "User updated successfully",
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
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // =========================================================
  // DASHBOARD HOME
  // =========================================================

  Widget dashboardHome() {
    return StreamBuilder<QuerySnapshot>(
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
            child: Text(
              "Error: ${snapshot.error}",
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text("No data found"),
          );
        }

        final users = snapshot.data!.docs;

        int approved = 0;
        int pending = 0;
        int rejected = 0;

        for (var doc in users) {
          final data =
              doc.data() as Map<String, dynamic>;

          final status =
              data["status"]?.toString().toLowerCase() ??
                  "pending";

          if (status == "approved") {
            approved++;
          } else if (status == "rejected") {
            rejected++;
          } else {
            pending++;
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              const Text(
                "Dashboard",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 15,
                runSpacing: 15,

                children: [
                  dashboardCard(
                    "Total Users",
                    users.length.toString(),
                    Icons.people,
                  ),

                  dashboardCard(
                    "Approved",
                    approved.toString(),
                    Icons.check_circle,
                  ),

                  dashboardCard(
                    "Pending",
                    pending.toString(),
                    Icons.pending,
                  ),

                  dashboardCard(
                    "Rejected",
                    rejected.toString(),
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

  // =========================================================
  // DASHBOARD CARD
  // =========================================================

  Widget dashboardCard(
    String title,
    String value,
    IconData icon,
  ) {
    return SizedBox(
      width: 210,

      child: Card(
        elevation: 3,

        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
              ),

              const SizedBox(height: 10),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // PRODUCT PAGE
  // =========================================================

  Widget productPage() {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: [
              const Text(
                "Products",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              ElevatedButton.icon(
                onPressed: showProductDialog,
                icon: const Icon(Icons.add),
                label: const Text("Add Product"),
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
                    child: Text(
                      "Error: ${snapshot.error}",
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No products found",
                    ),
                  );
                }

                final products =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount: products.length,

                  itemBuilder: (context, index) {
                    final doc = products[index];

                    final data =
                        doc.data()
                            as Map<String, dynamic>;

                    final name =
                        data["name"]?.toString() ?? "";

                    final price =
                        data["price"]?.toString() ?? "0";

                    final description =
                        data["description"]?.toString() ??
                            "";

                    return Card(
                      margin:
                          const EdgeInsets.only(bottom: 10),

                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            name.isNotEmpty
                                ? name[0].toUpperCase()
                                : "?",
                          ),
                        ),

                        title: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          "Price: Rs. $price\n$description",
                        ),

                        isThreeLine: true,

                        trailing: Row(
                          mainAxisSize:
                              MainAxisSize.min,

                          children: [
                            IconButton(
                              onPressed: () {
                                editProduct(
                                  doc.id,
                                  data,
                                );
                              },

                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                deleteProduct(
                                  doc.id,
                                );
                              },

                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
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

  // =========================================================
  // USER PAGE
  // =========================================================

  Widget userPage() {
    return Padding(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            "User Management",
            style: TextStyle(
              fontSize: 24,
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
                    child: Text(
                      "Error: ${snapshot.error}",
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No users found",
                    ),
                  );
                }

                final users =
                    snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,

                  itemBuilder: (context, index) {
                    final doc = users[index];

                    final data =
                        doc.data()
                            as Map<String, dynamic>;

                    final name =
                        data["name"]?.toString() ?? "";

                    final email =
                        data["email"]?.toString() ?? "";

                    final age =
                        data["age"]?.toString() ?? "";

                    final status =
                        data["status"]
                                ?.toString()
                                .toLowerCase() ??
                            "pending";

                    return Card(
                      margin:
                          const EdgeInsets.only(bottom: 10),

                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            name.isNotEmpty
                                ? name[0].toUpperCase()
                                : "?",
                          ),
                        ),

                        title: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          "$email\nAge: $age\nStatus: $status",
                        ),

                        isThreeLine: true,

                        trailing:
                            PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "approve") {
                              approveUser(doc.id);
                            }

                            if (value == "reject") {
                              rejectUser(doc.id);
                            }

                            if (value == "edit") {
                              editUser(
                                doc.id,
                                data,
                              );
                            }

                            if (value == "delete") {
                              deleteUser(doc.id);
                            }
                          },

                          itemBuilder: (context) {
                            return const [
                              PopupMenuItem(
                                value: "approve",
                                child: Text("Approve"),
                              ),

                              PopupMenuItem(
                                value: "reject",
                                child: Text("Reject"),
                              ),

                              PopupMenuItem(
                                value: "edit",
                                child: Text("Edit"),
                              ),

                              PopupMenuItem(
                                value: "delete",
                                child: Text("Delete"),
                              ),
                            ];
                          },
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

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final pages = [
      dashboardHome(),
      userPage(),
      productPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
        ),

        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: pages[selectIndex],

      bottomNavigationBar:
          BottomNavigationBar(
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
