import 'package:flutter/material.dart';
import 'package:flutter_api/api/api_service.dart';
import 'package:flutter_api/api/auth_service.dart';
import 'package:flutter_api/models/product.dart';
import 'package:flutter_api/screens/login_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  ApiService apiService = ApiService();
  AuthService authService = AuthService();
  List<Product> products = [];

  Future<void> fetchProduct() async {
    final data = await ApiService().fetchProducts();
    setState(() {
      products = data;
    });
  }

  @override
  void initState(){
    super.initState();
    fetchProduct();
  }

  void logout() async {
    await AuthService().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      ListView(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 45),
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/create-product').then((value){
                if (value == true) {
                  setState(() {
                    fetchProduct();
                  });
                }
              });
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.amber
              ),
              child: Center(
                child: Text("Tambah Data"),
              ),
            ),
          ),

          InkWell(
            onTap: () => logout(),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey
              ),
              child: Center(
                child: Text("Logout"),
              ),
            ),
          ),

          ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index){
              final product = products[index];
              return Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Color(0xffe1e1e1),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(product.shortDescription),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () async {
                            await ApiService().deleteProduct(product.id); // Tunggu proses hapus selesai
                            setState(() {}); // Memicu perubahan UI
                            fetchProduct(); // Ambil ulang data setelah setState()
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.lightGreenAccent
                            ),
                            child: Center(
                              child: Text("Hapus"),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/edit-product', arguments: product).then((value){
                              if (value == true) {
                                setState(() {
                                  fetchProduct();
                                });
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.amber
                            ),
                            child: Center(
                              child: Text("Edit"),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
          }),
        ],
      ),
    );
  }
}